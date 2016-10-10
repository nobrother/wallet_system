{if $cart.wallet_system}

{assign var="c_url" value=$config.current_url|escape:url}
    {foreach from=$cart.wallet_system item="wallet" key="wallet_key" name="f_wallet_system"}
        <li class="ty-order-products__item">
            
                <strong>{__("wallet_recharge")}</strong>
                {include file="buttons/button.tpl" but_href="wallet_system.clear_cart?redirect_url=`$c_url`" but_meta="ty-order-products__item-delete cm-post delete" but_target_id="cart_status*" but_role="delete" but_name="delete_cart_item"}
       
            <div class="ty-order-products__price">{include file="common/price.tpl" value=$wallet.recharge_amount}</div>
        </li>
    {/foreach}
{/if}