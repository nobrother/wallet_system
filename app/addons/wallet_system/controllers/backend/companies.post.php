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
use Tygh\Settings;
use Tygh\BlockManager\Layout;
use Tygh\Themes\Styles;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($mode == 'balance') {

        list($payouts, $search, $total) = fn_companies_get_payouts_wallet_system($_REQUEST, Registry::get('settings.Appearance.admin_elements_per_page'));

        Tygh::$app['view']->assign('payouts', $payouts);
        Tygh::$app['view']->assign('search', $search);
        Tygh::$app['view']->assign('total', $total);
    }