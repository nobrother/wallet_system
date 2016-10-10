{include file="common/letter_header.tpl"}

Dear {$wallet_data.user_name},<br /><br />

Congratulations!<br /><br />

You have successfully top up <b>{include file="common/price.tpl" value=$wallet_data.amount}</b> in your Red Deals wallet and the amount will be reflected in your account. <br /><br />

Please find below your updated wallet details:<br /><br />

{if !empty($wallet_data.refund_reason)}
Reason: {$wallet_data.refund_reason}<br />
{/if}
Top up amount: {include file="common/price.tpl" value=$wallet_data.amount}<br />
Current Wallet Amount: {include file="common/price.tpl" value=$wallet_data.total_cash}<br /><br />


If you have any further enquiries, please contact our customer service at <a href="mailto:cs@reddeals.my">cs@reddeals.my</a><br /><br />

Thank you for shopping with us.<br /><br />

RED DEALS

{include file="common/letter_footer.tpl"}