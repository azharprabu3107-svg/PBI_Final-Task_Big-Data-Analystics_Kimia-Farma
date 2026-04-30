# **Virtual Internship Experience: Big Data Analytics - Kimia Farma**
Tools : |📁 GitHub |📝 SQL Query |💻 Google BigQuery |📊 Google Looker Studio

## **📁 Introduction**
Virtual Internship Experience Big Data Analytics Kimia Farma adalah virtual internship experience yang difasilitasi oleh Rakamin Academy. Pada project internship ini saya berperan sebagai Big Data Analyst Intern yang diminta untuk menganalisis dan juga membuat laporan penjualan dalam bentuk dashboard interaktif menggunakan dataset yang sudah disediakan oleh pihak Kimia Farma. Project ini juga mengajarkan saya mengenai data warehouse, datalake dan datamart sebagai materi pendahuluan.

### **01: Data Preparation with Google BigQuery**
Pada tahap ini merupakan tahap persiapan dimana pada tahap ini saya membuat datamart sebelum nantinya merancang dashboard analisis.
1. Download dataset yang sudah diberikan untuk bahan analisis

**kf_final_transaction.csv**

  - transaction_id: kode id transaksi
  - product_id : kode produk obat
  - branch_id: kode id cabang Kimia Farma
  - customer_name: nama customer yang melakukan transaksi
  -	date: tanggal transaksi dilakukan
  -	price: harga obat
  -	discount_percentage: Persentase diskon yang diberikan pada obat
  -	rating: penilaian konsumen terhadap transaksi yang dilakukan.

  **kf_product.csv**
  -	product_id: kode produk obat
  -	product_name: nama produk obat
  -	product_category: kategori produk obat
  -	price: harga obat.

  **kf_inventory.csv**
  -	inventory_id: kode inventory produk obat
  -	branch_id: kode id cabang Kimia Farma
  -	product_id: kode id produk obat
  -	product_name: nama produk obat
  -	opname_stock: jumlah stok produk obat

  **kf_kantor_cabang.csv**
  - branch_id: kode id cabang Kimia Farma
  -	branch_category: kategori cabang Kimia Farma
  -	branch_name: nama kantor cabang Kimia Farma
  -	kota: kota cabang Kimia Farma
  -	provinsi: provinsi cabang Kimia Farma
  -	rating: penilaian konsumen terhadap cabang Kimia Farma

2.	Buka Google BigQuery dan buat project baru dengan nama “Rakamin-KF-Analytics”.
3.	Buat database baru dengan nama “kimia_farma” dan import semua dataset yang sudah diberikan dan di download .
4.	Buat datamart dengan menggabungkan semua dataset yang sudah diimport sebelumnya.

<details>

<summary>SQL Query</summary>

```sql
CREATE OR REPLACE TABLE `rakamin_kf_analytics.kimia_farma.kf_analisa` AS
SELECT
  t.transaction_id,
  DATE(t.date) AS date,
  t.branch_id,
  c.branch_name,
  c.kota,
  c.provinsi,
  c.rating AS rating_cabang,
  t.customer_name,
  t.product_id,
  p.product_name,
  t.price AS actual_price,
  t.discount_percentage,

  CASE
    WHEN t.price <= 50000 THEN 0.10
    WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
    WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
    WHEN t.price > 500000 THEN 0.30
  END AS persentase_gross_laba,

  ROUND(t.price * (1 - t.discount_percentage), 2) AS nett_sales,

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

  t.rating AS rating_transaksi
FROM `rakamin_kf_analytics.kimia_farma.kf_final_transaction` t
LEFT JOIN `rakamin_kf_analytics.kimia_farma.kf_kantor_cabang` c
  ON t.branch_id = c.branch_id
LEFT JOIN `rakamin_kf_analytics.kimia_farma.kf_product` p
  ON t.product_id = p.product_id;

 ```

</details>

### **02: Dashboard Design**
Setelah data dipersiapkan, proses selanjutnya adalah mendesain dashboard untuk business performance analysis menggunakan Google Looker Studio. Ini link untuk dashboard interaktif : [Interaktif Dashboard](https://datastudio.google.com/u/0/reporting/c0901f06-c4dc-4f39-8e7a-697216158e6e/page/p_rgj2qvgz2d).

Berikut merupakan dataset yang sudah di import ke dalam Google Big Query : [BigQuery](https://console.cloud.google.com/bigquery?project=rakamin-kf-analytics-494004&ws=!1m0).

![image](https://github.com/azharprabu3107-svg/PBI_Final-Task_Big-Data-Analystics_Kimia-Farma/blob/main/dashboard%201.PNG)
![image](https://github.com/azharprabu3107-svg/PBI_Final-Task_Big-Data-Analystics_Kimia-Farma/blob/main/dashboard%202.PNG)

**Berdasarkan analisis yang dilakukan dengan menggunakan dashboard, berikut informasi utama yang dapat saya simpulkan :**
1. Provinsi Jawa Barat secara signifikan mengungguli wilayah lain dalam penjualan bersih (nett sales) dalam volume transaksi (transaction volume).
2. Kimia Farma berhasil mempertahankan pendapatan triwulan yang stabil meskipun terdapat fluktuasi ekonomi, hal ini menunjukkan ketahanan dan strategi pasar yang digunakan efektif. Pendapatan relatif konsisten di seluruh kuartal mulai dari tahun 2020 sampai 2023.
3. Peringkat kepuasan cabang secara keseluruhan berkisar antara 4.0 hingga 4.6 yang mana hal ini menunjukkan kualitas layanan yang baik.
4. Terdapat variabilitas lain dalam hal kinerja cabang, yang mana ada terdapat beberapa cabang yang secara signifikan mengungguli cabang lain dalam hal penjualan dan transaksi. Meskipun begitu ada cabang yang memilik rating tinggi tetapi justru rating transaksinya rendah.

