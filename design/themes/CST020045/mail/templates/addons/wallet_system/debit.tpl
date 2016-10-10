{assign var=extra_info value=unserialize($wallet_data.extra_info)}

{include file="common/letter_header.tpl"}

{if $wallet_data.source == 'debit_by_admin'}
	{include file="addons/wallet_system/templates/debit_by_admin.tpl" wallet_data=$wallet_data extra_info=$extra_info}
{elseif isset($extra_info.reciever_email)}
	{include file="addons/wallet_system/templates/debit_transfer.tpl" wallet_data=$wallet_data extra_info=$extra_info}
{else}
	{include file="addons/wallet_system/templates/debit_order.tpl" wallet_data=$wallet_data extra_info=$extra_info}
{/if}

{include file="common/letter_footer.tpl"}