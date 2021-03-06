<?php


use Tygh\Http;
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

define('MAX_PAYPAL_PRODUCTS', 100);

// Return from paypal website
if (defined('PAYMENT_NOTIFICATION')) {
    if ($mode == 'return') {
        if (fn_check_payment_script('paypal.php', $_REQUEST['order_id'])) {
            $order_info = fn_get_order_info($_REQUEST['order_id'], true);

            if ($order_info['status'] == STATUS_INCOMPLETED_ORDER) {
                fn_change_order_status($_REQUEST['order_id'], 'O', '', false);
            }

            if (fn_allowed_for('MULTIVENDOR')) {
                if ($order_info['status'] == STATUS_PARENT_ORDER) {
                    $child_orders = db_get_hash_single_array("SELECT order_id, status FROM ?:orders WHERE parent_order_id = ?i", array('order_id', 'status'), $_REQUEST['order_id']);

                    foreach ($child_orders as $order_id => $order_status) {
                        if ($order_status == STATUS_INCOMPLETED_ORDER) {
                            fn_change_order_status($order_id, 'O', '', false);
                        }
                    }
                }
            }
        }
        fn_order_placement_routines('route', $_REQUEST['order_id'], false);

    } elseif ($mode == 'cancel') {
        $order_info = fn_get_order_info($_REQUEST['order_id']);

        $pp_response['order_status'] = 'N';
        $pp_response["reason_text"] = __('text_transaction_cancelled');

        if (!empty($_REQUEST['payer_email'])) {
            $pp_response['customer_email'] = $_REQUEST['payer_email'];
        }
        if (!empty($_REQUEST['payer_id'])) {
            $pp_response['client_id'] = $_REQUEST['payer_id'];
        }
        if (!empty($_REQUEST['memo'])) {
            $pp_response['customer_notes'] = $_REQUEST['memo'];
        }
        fn_finish_payment($_REQUEST['order_id'], $pp_response, false);
        fn_order_placement_routines('route', $_REQUEST['order_id']);
    }

} else {

    $paypal_account = $processor_data['processor_params']['account'];

    if ($processor_data['processor_params']['mode'] == 'test') {
        $paypal_url = "https://www.sandbox.paypal.com/cgi-bin/webscr";
    } else {
        $paypal_url = "https://www.paypal.com/cgi-bin/webscr";
    }

    $paypal_currency = $processor_data['processor_params']['currency'];
    $paypal_item_name = $processor_data['processor_params']['item_name'];
    //Order Total
    $paypal_shipping = fn_order_shipping_cost($order_info);
    $paypal_total = fn_format_price($order_info['total'] - $paypal_shipping, $paypal_currency);
    $paypal_shipping = fn_format_price($paypal_shipping, $paypal_currency);
    $paypal_order_id = $processor_data['processor_params']['order_prefix'].(($order_info['repaid']) ? ($order_id .'_'. $order_info['repaid']) : $order_id);

    $_phone = preg_replace('/[^\d]/', '', $order_info['phone']);
    $_ph_a = $_ph_b = $_ph_c = '';

    if ($order_info['b_country'] == 'US') {
        $_phone = substr($_phone, -10);
        $_ph_a = substr($_phone, 0, 3);
        $_ph_b = substr($_phone, 3, 3);
        $_ph_c = substr($_phone, 6, 4);
    } elseif ($order_info['b_country'] == 'GB') {
        if ((strlen($_phone) == 11) && in_array(substr($_phone, 0, 2), array('01', '02', '07', '08'))) {
            $_ph_a = '44';
            $_ph_b = substr($_phone, 1);
        } elseif (substr($_phone, 0, 2) == '44') {
            $_ph_a = '44';
            $_ph_b = substr($_phone, 2);
        } else {
            $_ph_a = '44';
            $_ph_b = $_phone;
        }
    } elseif ($order_info['b_country'] == 'AU') {
        if ((strlen($_phone) == 10) && $_phone[0] == '0') {
            $_ph_a = '61';
            $_ph_b = substr($_phone, 1);
        } elseif (substr($_phone, 0, 2) == '61') {
            $_ph_a = '61';
            $_ph_b = substr($_phone, 2);
        } else {
            $_ph_a = '61';
            $_ph_b = $_phone;
        }
    } else {
        $_ph_a = substr($_phone, 0, 3);
        $_ph_b = substr($_phone, 3);
    }

    // US states
    if ($order_info['b_country'] == 'US') {
        $_b_state = $order_info['b_state'];
    // all other states
    } else {
        $_b_state = fn_get_state_name($order_info['b_state'], $order_info['b_country']);
    }

    $return_url = fn_url("payment_notification.return?payment=paypal&order_id=$order_id", AREA, 'current');
    $cancel_url = fn_url("payment_notification.cancel?payment=paypal&order_id=$order_id", AREA, 'current');
    $notify_url = fn_url("payment_notification.paypal_ipn", AREA, 'current');

    $post_data = array(
        'charset' => 'utf-8',
        'cmd' => '_cart',
        'custom' => $order_id,
        'invoice' => $paypal_order_id,
        'redirect_cmd' => '_xclick',
        'rm' => 2,
        'email' => $order_info['email'],
        'first_name' => $order_info['b_firstname'],
        'last_name' => $order_info['b_lastname'],
        'address1' => $order_info['b_address'],
        'address2' => $order_info['b_address_2'],
        'country' => $order_info['b_country'],
        'city' => $order_info['b_city'],
        'state' => $_b_state,
        'zip' => $order_info['b_zipcode'],
        'day_phone_a' => $_ph_a,
        'day_phone_b' => $_ph_b,
        'day_phone_c' => $_ph_c,
        'night_phone_a' => $_ph_a,
        'night_phone_b' => $_ph_b,
        'night_phone_c' => $_ph_c,
        'business' => $paypal_account,
        'item_name' => $paypal_item_name,
        'amount' => $paypal_total,
        'upload' => '1',
        'shipping_1' => $paypal_shipping,
        'currency_code' => $paypal_currency,
        'return' => $return_url,
        'cancel_return' => $cancel_url,
        'notify_url' => $notify_url,
        'bn' => 'ST_ShoppingCart_Upload_US',
    );

    $i = 1;
    if(isset($order_info['wallet_system']['recharge_amount'])&&$order_info['wallet_system']['recharge_amount']>0.0)
    {
        $products=array(
            'item_name_1'=>'wallet recharge',
            'amount_1'=>$paypal_total,
            'quantity_1'=>1,
        );
        $order_info['products']=$products;
    }
   
    // Products
    if (empty($order_info['use_gift_certificates']) && !floatval($order_info['subtotal_discount']) && empty($order_info['points_info']['in_use']) && count($order_info['products']) < MAX_PAYPAL_PRODUCTS) {
        if (!empty($order_info['products'])) {
            foreach ($order_info['products'] as $k => $v) {
                $suffix = '_'.($i++);
                $v['product'] = htmlspecialchars(strip_tags($v['product']));
                $v['price'] = fn_format_price(($v['subtotal'] - fn_external_discounts($v)) / $v['amount'], $paypal_currency);
                $post_data["item_name$suffix"] = $v['product'];
                $post_data["amount$suffix"] = $v['price'];
                $post_data["quantity$suffix"] = $v['amount'];
                if (!empty($v['product_options'])) {
                    foreach ($v['product_options'] as $_k => $_v) {
                        $_v['option_name'] = htmlspecialchars(strip_tags($_v['option_name']));
                        $_v['variant_name'] = htmlspecialchars(strip_tags($_v['variant_name']));
                        $post_data["on$_k$suffix"] = $_v['option_name'];
                        $post_data["os$_k$suffix"] = $_v['variant_name'];
                    }
                }
            }
        }

        if (!empty($order_info['taxes']) && Registry::get('settings.General.tax_calculation') == 'subtotal') {
            foreach ($order_info['taxes'] as $tax_id => $tax) {
                if ($tax['price_includes_tax'] == 'Y') {
                    continue;
                }
                $suffix = '_' . ($i++);
                $item_name = htmlspecialchars(strip_tags($tax['description']));
                $item_price = fn_format_price($tax['tax_subtotal'], $paypal_currency);
                $post_data["item_name$suffix"] = $item_name;
                $post_data["amount$suffix"] = $item_price;
                $post_data["quantity$suffix"] = '1';
            }
        }

        // Gift Certificates
        if (!empty($order_info['gift_certificates'])) {
            foreach ($order_info['gift_certificates'] as $k => $v) {
                $suffix = '_'.($i++);
                $v['gift_cert_code'] = htmlspecialchars($v['gift_cert_code']);
                $v['amount'] = (!empty($v['extra']['exclude_from_calculate'])) ? 0 : fn_format_price($v['amount'], $paypal_currency);
                $post_data["item_name$suffix"] = $v['gift_cert_code'];
                $post_data["amount$suffix"] = $v['amount'];
                $post_data["quantity$suffix"] = '1';
            }
        }

        if (fn_allowed_for('MULTIVENDOR') && fn_take_payment_surcharge_from_vendor('')) {
            $take_surcharge = false;
        } else {
            $take_surcharge = true;
        }

        // Payment surcharge
        if ($take_surcharge && floatval($order_info['payment_surcharge'])) {
            $suffix = '_' . ($i++);
            $name = __('surcharge');
            $payment_surcharge_amount = fn_format_price($order_info['payment_surcharge'], $paypal_currency);
            $post_data["item_name$suffix"] = $name;
            $post_data["amount$suffix"] = $payment_surcharge_amount;
            $post_data["quantity$suffix"] = '1';
        }
    } elseif ($paypal_total == 0) {
        // Move shipping price to order total to avoid blocking order with zero products price
        $total_description = __('total_product_cost');
        $post_data['item_name_1'] = $total_description;
        $post_data['amount_1'] = $paypal_shipping;
        $post_data['quantity_1'] = '1';
        $post_data['amount'] = $paypal_shipping;
        $post_data['handling_cart'] = 0;

    } else {
        $total_description = __('total_product_cost');
        $post_data["item_name_1"] = $total_description;
        $post_data["amount_1"] = $paypal_total;
        $post_data["quantity_1"] = '1';
    }

    fn_create_payment_form($paypal_url, $post_data, 'PayPal server', false);
}
exit;
