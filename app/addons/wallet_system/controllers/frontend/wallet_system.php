<?php
/******************************************************************
# Wallet - Wallet                                                 *
# ----------------------------------------------------------------*
# author    Webkul                                                *
# copyright Copyright (C) 2010 webkul.com. All Rights Reserved.   *
# @license - http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL     *
# Websites: http://webkul.com                                     *
*******************************************************************
*/ 

use Tygh\Registry;
use Tygh\Navigation\LastView;


if (!defined('BOOTSTRAP')) { die('Access denied'); }


if($mode == 'create_transfer')
{
     $suffix="wallet_system.my_wallet&email=".$_REQUEST['wallet_transfer_system']['transfer_email']."&amount=".$_REQUEST['wallet_transfer_system']['transfer_amount'];
     if(Registry::get('addons.wallet_system.status_wallet_transfer') == 'N')
     {
       return array(CONTROLLER_STATUS_DENIED);
     }

     if($_REQUEST['wallet_transfer_system']['transfer_email'] == db_get_field("SELECT email FROM ?:users WHERE user_id =?i",$_SESSION['auth']['user_id']))
     {
       fn_set_notification('E',__("error"),__("can_not_transfer_to_own_email"));
      return array(CONTROLLER_STATUS_REDIRECT,$suffix);
     }
    $get_transfer_min=Registry::get('addons.wallet_system.min_transfer_amount');
    $get_transfer_max=Registry::get('addons.wallet_system.max_transfer_amount');
    $get_user_wallet_amount=fn_get_wallet_amount(null,$_SESSION['auth']['user_id']);
    
    $transfer_email_id=trim($_REQUEST['wallet_transfer_system']['transfer_email']);
    $transfer_user_id=db_get_field("SELECT user_id FROM ?:users WHERE email = ?s",$transfer_email_id);
    $check_amount=is_numeric($_REQUEST['wallet_transfer_system']['transfer_amount']);
    if(empty($check_amount))
    {
      fn_set_notification('W',__("amount_error"),__("please_insert_only_numeric_value"));
      return array(CONTROLLER_STATUS_REDIRECT,$suffix);
    }
    if($_REQUEST['wallet_transfer_system']['transfer_amount'] > $get_user_wallet_amount)
    {
      fn_set_notification('W',__("amount_error"),__("transfer_amount_is_more_than_available_cash"));
      return array(CONTROLLER_STATUS_REDIRECT, $suffix);
    }
    if($get_transfer_max < $_REQUEST['wallet_transfer_system']['transfer_amount']||$_REQUEST['wallet_transfer_system']['transfer_amount'] < $get_transfer_min)
    {
      $error_msg=__("transfer_limit_is").$get_transfer_min.__("_to_").$get_transfer_max;
      fn_set_notification('W',__("amount_error"),$error_msg);
      return array(CONTROLLER_STATUS_REDIRECT, $suffix);
    }

    if(empty($transfer_user_id))
    {
      fn_set_notification('E',__("user_not_exist"),__("email_user_not_found_at_store"));
      return array(CONTROLLER_STATUS_REDIRECT, $suffix);
    }

    fn_create_transfer_for_user($_REQUEST['wallet_transfer_system']['transfer_email'],$_REQUEST['wallet_transfer_system']['transfer_amount']);
    fn_set_notification('N',__("success"),__("transfer_completed_successfully"));

    return array(CONTROLLER_STATUS_REDIRECT, "wallet_system.my_wallet");
}

if ( $mode == 'my_wallet' ){
	
	// User must login
	if ($_SESSION['auth']['user_id'] == 0)
		return array( CONTROLLER_STATUS_REDIRECT, "auth.login_form" );
	
	// Breadcrumb
	fn_add_breadcrumb( __('my_wallet_details') );
	
	// If user can transfer credit
	if( Registry::get('addons.wallet_system.status_wallet_transfer') == 'Y'	){
		
		Registry::get('view')->assign( 'enable_transfer',"Y" );		 
		
		if( isset( $_REQUEST['email'] ) )
			Registry::get('view')->assign('transfer_email',$_REQUEST['email']);
		
		if( isset( $_REQUEST['amount'] ) )
			Registry::get('view')->assign('transfer_amount',$_REQUEST['amount']);
	} 
	
	else
		Registry::get('view')->assign('enable_transfer',"N");

  // If user can top up
  if( Registry::get('addons.wallet_system.status_wallet_recharge') == 'Y' )    
    Registry::get('view')->assign( 'enable_top_up',"Y" );
  else
    Registry::get('view')->assign('enable_top_up',"N");
    
  // Wallet info
	Registry::get('view')->assign('total_cash',fn_get_wallet_amount($wallet_id=null,$user_id=$auth['user_id']));
	Registry::get('view')->assign('primary_currency',CART_PRIMARY_CURRENCY);		
   
	// Wallet transaction
	list( $wallet_transactions, $search ) = fn_get_wallet_transactions( $_REQUEST, Registry::get('settings.Appearance.elements_per_page'), $_SESSION['auth']['user_id'] );
         
	Registry::get('view')->assign('wallet_transactions', $wallet_transactions);
	Registry::get('view')->assign('search', $search);
}


if ($mode == 'cash_add_wallet')
 {      
    
    if(empty($_SESSION['auth']['user_id']))
    {
        fn_set_notification("E","wallet_recharge",__("please_login_first"));

         return array(CONTROLLER_STATUS_REDIRECT, "auth.login");
    }
   
    $min = Registry::get('addons.wallet_system.min_recharge_amount');
    $max = Registry::get('addons.wallet_system.max_recharge_amount');

    
    if ($_REQUEST['wallet_system']['recharge_amount'] < $min || $_REQUEST['wallet_system']['recharge_amount'] > $max)
     {

        fn_set_notification('W', __('wallet_error'), __('can_not_proceed_please_check_limit'));
        fn_set_notification("N",__("wallet_limit"),__("wallet_limit_is").$min.__("_to_").$max);
        return array(CONTROLLER_STATUS_REDIRECT, "wallet_system.my_wallet");
      }  

    
    if(!empty($_SESSION['cart']['products']))
    {
        fn_set_notification("E",__("wallet_recharge"),__("remove_product_from_cart"));

        return array(CONTROLLER_STATUS_REDIRECT, "wallet_system.my_wallet"); 
    }

    if(!empty($_SESSION['cart']['gift_certificates']))
    {
        fn_set_notification("E","wallet_recharge",__("remove_product_from_cart"));

        return array(CONTROLLER_STATUS_REDIRECT, "wallet_system.my_wallet"); 
    }
   
    $_SESSION['cart']['wallet_system'] = array();

    $_wr = array();
    $_wr[] = TIME;

    $wallet_system=$_REQUEST['wallet_system'];
    if (!empty($wallet_system)) {

        foreach ($wallet_system as $k => $v) {
         
                $_wr[] = $v;
            }
        }

    $wallet_cart_id=fn_crc32(implode('_', $_wr));

      if (!empty($wallet_cart_id)) {
                 
                $wallet_system['wallet_cart_id'] = $wallet_cart_id;

                $wallet_system['display_subtotal'] = $wallet_system['recharge_amount'];
         
                $_SESSION['cart']['wallet_system'][$wallet_cart_id] = $wallet_system;

                fn_calculate_cart_content($_SESSION['cart'], $auth, 'S', true, 'F', true);
                
                $wallet_system['display_subtotal'] = $_SESSION['cart']['wallet_system'][$wallet_cart_id]['display_subtotal'];
                                  
                Registry::get('view')->assign('wallet_system', $wallet_system);
                $msg = Registry::get('view')->fetch('views/checkout/components/product_notification.tpl');
                fn_set_notification('I', __('money_added_in_cart_please_make_a_paymnet'), $msg, 'I');
            }

            fn_save_cart_content($_SESSION['cart'], $auth['user_id']);

            if (defined('AJAX_REQUEST')) {
                fn_calculate_cart_content($_SESSION['cart'], $auth, false, false, 'F', false);
            }
    
        return array(CONTROLLER_STATUS_REDIRECT, "wallet_system.my_wallet");
    
 }



 if ($mode == 'wallet_transactions')
  {
    fn_add_breadcrumb(__('wallet_transactions'));
    if ($_SESSION['auth']['user_id'] == 0)
    {
      return array(CONTROLLER_STATUS_REDIRECT, "auth.login_form");
    }
        
    list($wallet_transactions, $search) = fn_get_wallet_transactions($_REQUEST, Registry::get('settings.Appearance.elements_per_page'),$_SESSION['auth']['user_id']);
         
    Registry::get('view')->assign('wallet_transactions', $wallet_transactions);
    Registry::get('view')->assign('search', $search);
  }

    if($mode == 'clear_cart')
    {
       $cart = & $_SESSION['cart'];
       fn_clear_cart($cart);
       fn_set_notification('N','notice',__("clear_cart_successfully"));
        return array(CONTROLLER_STATUS_REDIRECT);
    }

if($mode == 'apply_wallet_cash')
{
  $current_wallet_cash=fn_get_wallet_amount(null,$_SESSION['auth']['user_id']);
  $cart_total = $_SESSION['cart']['total'];

  if($cart_total >= $current_wallet_cash)
  {
    $_SESSION['cart']['wallet']['current_cash']= 0.0;
    $_SESSION['cart']['wallet']['used_cash']= $current_wallet_cash;
  }  
  else
  {
    $_SESSION['cart']['wallet']['current_cash']= $current_wallet_cash - $cart_total;
    $_SESSION['cart']['wallet']['used_cash']= $cart_total;
  }  
  return array(CONTROLLER_STATUS_REDIRECT, "checkout.checkout?wallet_cash_applied=yes");
}

if($mode == 'remove_wallet_cash')
{
  unset($_SESSION['cart']['wallet']);
  return array(CONTROLLER_STATUS_REDIRECT, "checkout.checkout");
}
