WITH DailyData AS (
  SELECT
    "date" AS "Day",
    DATE_TRUNC('month', "date") AS "Month",
    ROUND(btc_in_usd, 2) AS btc_in_usd,
    ROUND(elk_in_usd, 2) AS elk_in_usd,
    ROUND(weth_in_usd, 2) AS weth_in_usd,
    ROUND(stq_conv_rate, 2) AS stq_conv_rate,
    ROUND(vnxau_in_usd, 2) AS vnxau_in_usd,
    ROUND(bridged_wbtc, 2) AS bridged_wbtc,
    ROUND(bridged_usdc, 2) AS bridged_usdc,
    ROUND(bridged_dai, 2) AS bridged_dai,
    ROUND(bridged_weth, 2) AS bridged_weth,
    ROUND(bridged_elk, 2) AS bridged_elk,
    ROUND(bridged_wbtc * btc_in_usd + bridged_usdc * 1 + bridged_dai * 1 + bridged_elk * elk_in_usd + bridged_weth * weth_in_usd, 2) AS bridged_usd_value_calc,
    ROUND(total_qusd, 2) AS total_qusd,
    ROUND(locked_wbtc, 2) AS locked_wbtc,
    ROUND(locked_usdc, 2) AS locked_usdc,
    ROUND(locked_dai, 2) AS locked_dai,
    ROUND(locked_wbtc * btc_in_usd + locked_usdc * 1 + locked_dai * 1, 2) AS borrowing_tvl_calc,
    ROUND(saving_tvl, 2) AS saving_tvl,
    ROUND(elk_locked_wbtc, 2) AS elk_locked_wbtc,
    ROUND(elk_locked_usdc, 2) AS elk_locked_usdc,
    ROUND(elk_locked_dai, 2) AS elk_locked_dai,
    ROUND(elk_locked_elk, 2) AS elk_locked_elk,
    ROUND(elk_locked_qusd, 2) AS elk_locked_qusd,
    ROUND(elk_locked_vnxau, 2) AS elk_locked_vnxau,
    ROUND(elk_locked_wbtc * btc_in_usd + elk_locked_usdc * 1 + elk_locked_dai * 1 + elk_locked_elk * elk_in_usd + elk_locked_qusd * 1 + elk_locked_vnxau * vnxau_in_usd, 2) AS elk_tvl_calc,
    ROUND(stq_supply, 2) AS stq_supply,
    ROUND(stq_supply * stq_conv_rate * 0.33 , 2) AS metapool_tvl, 
    ROUND(elk_locked_wbtc * btc_in_usd + elk_locked_usdc * 1 + elk_locked_dai * 1 + elk_locked_elk * elk_in_usd + elk_locked_qusd * 1 + elk_locked_vnxau * vnxau_in_usd + locked_wbtc * btc_in_usd + locked_usdc * 1 + locked_dai * 1 + saving_tvl + stq_supply * stq_conv_rate * 0.33 , 2) AS total_tvl_wth_stq_calc,
    ROUND(elk_locked_wbtc * btc_in_usd + elk_locked_usdc * 1 + elk_locked_dai * 1 + elk_locked_elk * elk_in_usd + elk_locked_qusd * 1 + elk_locked_vnxau * vnxau_in_usd + locked_wbtc * btc_in_usd + locked_usdc * 1 + locked_dai * 1 + saving_tvl, 2) AS total_tvl_calc

  FROM
    dune."0xsg".token_and_contract_data
),
MonthlyAverages AS (
  SELECT
    DATE_TRUNC('month', "Day") AS "Month",
    ROUND(AVG(bridged_usd_value_calc), 2) AS avg_rec_bridged_usd_value,
    ROUND(AVG(borrowing_tvl_calc), 2) AS avg_rec_borrowing_tvl,
    ROUND(AVG(elk_tvl_calc), 2) AS avg_rec_elk_tvl,
    ROUND(AVG(saving_tvl), 2) AS avg_saving_tvl, 
    ROUND(AVG(total_tvl_calc), 2) AS avg_rec_total_tvl
   
  FROM
    DailyData
  GROUP BY
    DATE_TRUNC('month', "Day")
)
SELECT
  d.*,
  m.avg_rec_bridged_usd_value,
  m.avg_rec_borrowing_tvl,
  m.avg_rec_elk_tvl,
  m.avg_saving_tvl,
  m.avg_rec_total_tvl
FROM
  DailyData d
LEFT JOIN
  MonthlyAverages m ON d."Month" = m."Month"
ORDER BY
  d."Day" ASC;
