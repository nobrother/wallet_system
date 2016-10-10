{include file="common/letter_header.tpl"}

Dear {$wallet_data.user_name},<br /><br />

Please note that 
{if !empty($wallet_data.order_id)}
	for Order No 
	<a href="{"orders.details&order_id=`$wallet_data.order_id`|fn_url"}">#{$wallet_data.order_id}</a>,
{/if}
<b>{include file="common/price.tpl" value=$wallet_data.amount}</b> has been deducted from your Red Deals wallet and it will be reflected in your account.<br /><br />

Please find below your updated wallet details:<br /><br />

{if !empty($wallet_data.order_id)}
	Order ID: <a href="{"orders.details&order_id=`$wallet_data.order_id`"|fn_url}">#{$wallet_data.order_id}</a><br />
{/if}
Deducted amount: {include file="common/price.tpl" value=$wallet_data.amount}<br />
Current Wallet Amount: {include file="common/price.tpl" value=$wallet_data.total_cash}<br /><br />

If you have any further enquiries, please contact our customer service at <a href="mailto:cs@reddeals.my">cs@reddeals.my</a><br /><br />

Red Deals

{include file="common/letter_footer.tpl"}