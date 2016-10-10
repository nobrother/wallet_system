{if $smarty.session.cart.wallet_system}
    {foreach from=$smarty.session.cart.wallet_system item="wallet" key="gift_key" name="f_wallet_system"}
    <li class="ty-cart-items__list-item">
        {if $block.properties.products_links_type == "thumb"}
        <div class="ty-cart-items__list-item-image">
            <img src="design/backend/media/images/addons/wallet_system/Wallet-Icon.png" width="40" height="40">
        </div>
        {/if}
        <div class="ty-cart-items__list-item-desc">
            
                <span>{__("wallet_recharge")}</span>
            
        <p>
            {include file="common/price.tpl" value=$wallet.recharge_amount span_id="subtotal_gc_`$gift_key`" class="none"}
        </p>
        </div>
        {if $block.properties.display_delete_icons == "Y"}
        {assign var="r_url" value=$config.current_url|escape:url}
        <div class="ty-cart-items__list-item-tools cm-cart-item-delete">
            {if (!$runtime.checkout || $force_items_deletion) && !$p.extra.exclude_from_calculate}{include file="buttons/button.tpl" but_href="wallet_system.clear_cart?redirect_url=`$r_url`" but_meta="cm-ajax cm-post cm-ajax-full-render" but_target_id="cart_status*" but_role="delete" but_name="delete_cart_item"}{/if}
        </div>
        {/if}
    </li>
    {/foreach}
{/if}
