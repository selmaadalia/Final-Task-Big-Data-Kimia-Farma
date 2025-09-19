-- New dataset
CREATE SCHEMA IF NOT EXISTS `kf_tabel_analisis`;

-- New table
CREATE TABLE `kf_tabel_analisis.kf_tabel_analisis` AS
SELECT
  kfft.transaction_id,
  kfft.date,
  kfkc.branch_id,
  kfkc.branch_name,
  kfkc.kota,
  kfkc.provinsi,
  kfkc.rating AS rating_cabang,
  kfft.customer_name,
  kfft.product_id,
  kfp.product_name,
  kfft.price AS actual_price,
  kfft.discount_percentage,

  -- Persentase gross laba
  CASE
    WHEN kfft.price <= 50000 THEN 0.10
    WHEN kfft.price > 50000 AND kfft.price <= 100000 THEN 0.15
    WHEN kfft.price > 100000 AND kfft.price <= 300000 THEN 0.20
    WHEN kfft.price > 300000 AND kfft.price <= 500000 THEN 0.25
    WHEN kfft.price > 500000 THEN 0.30
  END AS persentase_gross_laba,

  -- Nett sales
  kfft.price * (1 - (kfft.discount_percentage / 100)) AS nett_sales,

   -- Nett profit
  (kfft.price * (1 - kfft.discount_percentage / 100)) *
  CASE
    WHEN kfft.price <= 50000 THEN 0.10
    WHEN kfft.price > 50000 AND kfft.price <= 100000 THEN 0.15
    WHEN kfft.price > 100000 AND kfft.price <= 300000 THEN 0.20
    WHEN kfft.price > 300000 AND kfft.price <= 500000 THEN 0.25
    WHEN kfft.price > 500000 THEN 0.30
  END AS nett_profit,

  -- Rating transaksi
  kfft.rating AS rating_transaksi

FROM `rakaminacademy-kimiafarma.kf_final_transaction.kf_final_transaction` kfft

JOIN `rakaminacademy-kimiafarma.kf_product.kf_product` kfp
  ON kfft.product_id = kfp.product_id

JOIN `rakaminacademy-kimiafarma.kf_kantor_cabang.kf_kantor_cabang` kfkc
  ON kfft.branch_id = kfkc.branch_id;