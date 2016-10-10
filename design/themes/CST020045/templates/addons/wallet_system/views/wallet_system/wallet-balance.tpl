<div class="ty-wallet-balance">
	<span class="ty-wallet-balance-label">
	{if $label}{$label}{else}CURRENT BALANCE{/if}
	</span>
	<span class="ty-wallet-balance-amount">
		{include file="common/price.tpl" value=$value}
	</span>
</div>