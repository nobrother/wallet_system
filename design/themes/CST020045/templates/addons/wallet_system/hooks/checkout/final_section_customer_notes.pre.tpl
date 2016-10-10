{if isset($show_wallet)}
{if isset($cart.wallet.used_cash) && empty($cart.total)}
<div class="ty-wallet-checkout-section after-used">
    <h3 class="ty-step__title-active clearfix">
        <span class="ty-step__title-left"><img src="design/backend/media/images/addons/wallet_system/Wallet-Icon.png" width="20"></span>
        <span class="ty-step__title-txt">{__("user_wallet")}</span>
    </h3>
    
    <div class="ty-wallet-checkout-section-body">
        <div class="avaliable-wallet-cash-group">
            <span class="avaliable-wallet-cash-label">{__("available_wallet_cash")}:</span>
            <span class="avaliable-wallet-cash-amount">
                {include file="common/price.tpl" value=$cart.wallet.current_cash}
            </span>
        </div>

        {if isset($cart.wallet.used_cash)}
        
            <div style="wallet-used-cash-group">
                <i class="ty-icon-ok" ></i>
                <span class="wallet-used-cash-label">{__("applied_wallet_cash")}: </span>
                <span class="wallet-used-cash-amount">
                    {include file="common/price.tpl" value=$cart.wallet.used_cash}
                </span>
                <a href="{$config.customer_index}?dispatch=wallet_system.remove_wallet_cash" 
                    class="cm-ajax cm-ajax-force cm-ajax-full-render btn-remove-wallet-cash" 
                    data-ca-target-id="checkout_*">
                    <i title="Remove" class="ty-icon-cancel-circle" style="color:red; font-size:16px"></i>
                </a>
            </div>
        
        {else}
            <a href="{$config.customer_index}?dispatch=wallet_system.apply_wallet_cash" 
                class="ty-btn ty-btn__secondary cm-ajax cm-ajax-force cm-ajax-full-render btn-use-wallet-cash" 
                data-ca-target-id="checkout_*">
                    {__("use_wallet")}
            </a>
        {/if}
    </div>
</div>
<div class="ty-checkout-buttons ty-checkout-buttons__submit-order"></div>
{/if}
{/if}