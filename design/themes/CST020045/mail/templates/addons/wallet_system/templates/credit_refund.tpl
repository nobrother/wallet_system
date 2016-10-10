{include file="common/letter_header.tpl"}

Dear {$wallet_data.user_name},<br /><br />

Please note that you have receive the refund amount of <b>{include file="common/price.tpl" value=$wallet_data.amount}</b> from Red Deals. The amount will be reflected in your Red Deals wallet.

Please find below your updated wallet details:<br /><br />

{if $wallet_data.source eq 'refund_rma'}
    Return ID:
    <a href="{"rma.details?return_id=`$wallet_data.source_id`"|fn_url}">#{$wallet_data.source_id}</a><br />
{else}
    Order ID:
    <a href="{"orders.details?order_id=`$wallet_data.source_id`"|fn_url}">#{$wallet_data.source_id}</a><br />
{/if}
{if !empty($wallet_data.return_data)}
Reason: {$wallet_data.return_data.comment}<br />
{elseif !empty($wallet_data.refund_reason)}
Reason: {$wallet_data.refund_reason}<br />
{/if}
Refunded Amount: {include file="common/price.tpl" value=$wallet_data.amount}<br />
Current Wallet Amount: {include file="common/price.tpl" value=$wallet_data.total_cash}<br /><br />


If you have any further enquiries, please contact our customer service at <a href="mailto:cs@reddeals.my">cs@reddeals.my</a><br /><br />

Red Deals

{include file="common/letter_footer.tpl"}