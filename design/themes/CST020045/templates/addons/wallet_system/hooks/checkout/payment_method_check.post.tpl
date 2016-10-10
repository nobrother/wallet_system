{if isset($show_wallet)}
<div class="ty-wallet-checkout-section before-used">
    <h3 class="ty-step__title-active clearfix">
        <span class="ty-step__title-left"><img src="design/backend/media/images/addons/wallet_system/Wallet-Icon.png" width="20"></span>
        <span class="ty-step__title-txt">{__("user_wallet")}</span>
    </h3>
    
    <div class="ty-wallet-checkout-section-body">
        <div>{__("available_wallet_cash")}:
            <b>{include file="common/price.tpl" value=$cart.wallet.current_cash}</b>
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
            {if $cart.wallet.current_cash > 0.00}
                <a href="{$config.customer_index}?dispatch=wallet_system.apply_wallet_cash" 
                    class="ty-btn ty-btn__secondary cm-ajax cm-ajax-force cm-ajax-full-render btn-use-wallet-cash" 
                    data-ca-target-id="checkout_*">
                        {__("use_wallet")}
                </a>
            {/if}
        {/if}
    </div>  
</div>
<br><br>
<!--cm-ajax cm-ajax-force cm-ajax-full-render  -->
<!-- <i class="ty-icon-cancel" style="color:red"> -->
{/if}