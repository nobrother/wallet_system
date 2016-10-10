<?php
/******************************************************************
# Wallet--- Wallet                                                *
# ----------------------------------------------------------------*
# author    Webkul                                                *
# copyright Copyright (C) 2010 webkul.com. All Rights Reserved.   *
# @license - http://www.gnu.org/licenses/gpl-2.0.html GNU/GPL     *
# Websites: http://webkul.com                                     *
*******************************************************************
*/
use Tygh\Registry;

if($mode == 'details')
{
	$order_info = fn_get_order_info($_REQUEST['order_id']);
   
    if(isset($order_info['gift_certificates']))
    {

    }
    else
    { 	
      if(empty($order_info['products']))
      {

         Registry::get('view')->assign('wallet_recharge',"yes");
      }
    } 
    if(fn_check_permissions('rma','manage', 'admin', 'POST') && fn_check_permissions('rma','update', 'admin', 'POST'))
   {
     Registry::get('view')->assign('show_wallet_refund',"yes");
   } 
}
if ($mode == 'print_invoice') {
    if (!empty($_REQUEST['order_id'])) {
        fn_print_order_invoices($_REQUEST['order_id'], !empty($_REQUEST['format']) && $_REQUEST['format'] == 'pdf');
    }

} elseif ($mode == 'print_packing_slip') {
    if (!empty($_REQUEST['order_id'])) {
        fn_print_order_packing_slips($_REQUEST['order_id'], !empty($_REQUEST['format']) && $_REQUEST['format'] == 'pdf');
    }

}

