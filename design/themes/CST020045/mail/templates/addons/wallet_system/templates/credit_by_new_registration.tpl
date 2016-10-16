{include file="common/letter_header.tpl"}

Dear {$wallet_data.user_name},<br /><br />

Here’s a big shoutout to you on signing up with Red Deals! As a token of appreciation, we’re rewarding you <b>{include file="common/price.tpl" value=$wallet_data.amount}</b> in your E-wallet for you to kick start your shopping adventure with us. Please note that the rewarded amount will be reflected in your Red Deals account.<br /><br />

Please find below your updated wallet details:<br /><br />

Rewarded Amount: {include file="common/price.tpl" value=$wallet_data.amount}<br />
Current Wallet {include file="common/price.tpl" value=$wallet_data.total_cash}<br /><br />

If you have any further enquiries, please contact our customer service at <a href="mailto:cs@reddeals.my">cs@reddeals.my</a><br /><br />

Red Deals

{include file="common/letter_footer.tpl"}