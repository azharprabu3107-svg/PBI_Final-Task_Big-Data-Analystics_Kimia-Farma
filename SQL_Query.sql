/*
Author: Azhar Prabu Bagaskara
Date: 30/04/2026
Tool used: Google BigQuery 
*/

/* 
 SCRIPT: Pembuatan Tabel Analisa Kimia Farma
 TUJUAN: Menggabungkan data transaksi, cabang, dan produk serta menghitung metrik bisnis 
         seperti nett sales, persentase gross laba, dan nett profit berdasarkan tier harga.
 OUTPUT: Tabel `kf_analisa` yang siap digunakan untuk analisis, reporting, atau dashboard.
 */

CREATE OR REPLACE TABLE `rakamin_kf_analytics.kimia_farma.kf_analisa` AS
SELECT
  --Identitas transaksi & waktu
  t.transaction_id,  
  DATE(t.date) AS date,   -- Mengambil hanya komponen tanggal (menghilangkan jam/menit/detik)
  
  --Informasi cabang
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,

  --Informasi pelanggan & produk
  t.customer_name,
  t.product_id,
  p.product_name,

  --Harga & diskon
  t.price AS actual_price,   -- Harga asli produk sebelum diskon
  t.discount_percentage,     -- Persentase diskon yang diterapkan pada transaksi

  -- Persentase Gross Laba: ditentukan berdasarkan tier harga produk
  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
  END AS persentase_gross_laba,

  -- Nett Sales: Harga setelah dipotong diskon, dibulatkan ke 2 desimal
  ROUND(t.price * (1 - t.discount_percentage), 2) AS nett_sales,

  -- Nett Profit: Nett Sales dikalikan persentase gross laba sesuai tier harga, dibulatkan ke 2 desimal
  ROUND(
    (t.price * (1 - t.discount_percentage)) *
    CASE
      WHEN t.price <= 50000 THEN 0.10
      WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
      WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
      WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
      WHEN t.price > 500000 THEN 0.30
    END
  , 2) AS nett_profit,

  -- Rating kepuasan pelanggan pada transaksi ini
  t.rating AS rating_transaksi

-- Sumber data utama: tabel transaksi final
FROM `rakamin_kf_analytics.kimia_farma.kf_final_transaction` t

-- Menggabungkan data cabang berdasarkan branch_id
-- LEFT JOIN digunakan agar semua transaksi tetap muncul meskipun data cabang tidak lengkap
LEFT JOIN `rakamin_kf_analytics.kimia_farma.kf_kantor_cabang` c
  ON t.branch_id = c.branch_id

-- Menggabungkan data produk berdasarkan product_id
LEFT JOIN `rakamin_kf_analytics.kimia_farma.kf_product` p
  ON t.product_id = p.product_id;