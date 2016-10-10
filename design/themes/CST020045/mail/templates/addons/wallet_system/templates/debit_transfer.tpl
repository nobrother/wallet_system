{include file="common/letter_header.tpl"}

Dear {$wallet_data.user_name},<br /><br />

Hurray! Your have successfully transferred <b>{include file="common/price.tpl" value=$wallet_data.amount}</b> 
{if isset($wallet_data.extra_info.reciever_email)}
to {$wallet_data.extra_info.reciever_email}
{/if} and it will be reflected in your account.<br /><br />

Please find below your updated wallet details:<br /><br />

{if !empty($wallet_data.debit_reason)}
Reason: {$wallet_data.debit_reason}<br />
{/if}
{if isset($wallet_data.extra_info.reciever_email)}
Recipient: {$wallet_data.extra_info.reciever_email}<br />
{/if}
Transferred amount: {include file="common/price.tpl" value=$wallet_data.amount}<br />
Current Wallet Amount: {include file="common/price.tpl" value=$wallet_data.total_cash}<br /><br />

If you have any further enquiries, please contact our customer service at <a href="mailto:cs@reddeals.my">cs@reddeals.my</a><br /><br />

Red Deals

{include file="common/letter_footer.tpl"}