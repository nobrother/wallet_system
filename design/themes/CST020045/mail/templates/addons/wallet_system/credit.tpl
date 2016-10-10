{include file="common/letter_header.tpl"}

{if $wallet_data.source == 'recharge'}
    {include file="addons/wallet_system/templates/credit_top_up.tpl" wallet_data=$wallet_data}
{elseif $wallet_data.source == 'transfer'}
    {include file="addons/wallet_system/templates/credit_transfer.tpl" wallet_data=$wallet_data}
{elseif $wallet_data.source == 'credit_by_admin'}
		{include file="addons/wallet_system/templates/credit_by_admin.tpl" wallet_data=$wallet_data}
{else}
		{include file="addons/wallet_system/templates/credit_refund.tpl" wallet_data=$wallet_data}
{/if}

{include file="common/letter_footer.tpl"}