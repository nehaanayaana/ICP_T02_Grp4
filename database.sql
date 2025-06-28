----------------------------------------------------------------------------------------
--- This file contains the database schema and the data                              ---
--- You may add your own SQL queries for new tables or data in the end of this file  ---
--- Should you add your new table, please prefix with `np25<your_team_number>_`      ---
--- e.g. np2501_recommendations                                                      ---
----------------------------------------------------------------------------------------

--- Schema ---
--- Table 1: area ---
--- This table contains the areas ---
CREATE TABLE IF NOT EXISTS public.area
(
	-- ID of the area for internal use --
	id VARCHAR NOT NULL,
	-- The full name of the area --
	"name" VARCHAR NULL,
	-- The level 0 of the area (Country) --
	level_0 VARCHAR NULL,
	-- The level 1 of the area (Province) --
	level_1 VARCHAR NULL,
	-- The level 2 of the area (Regency) --
	level_2 VARCHAR NULL,
	-- The level 3 of the area (District) --
	level_3 VARCHAR NULL,
	-- The latitude of the level 3 of the area --
	level_3_latitude float NULL,
	-- The longitude of the level 3 of the area --
	level_3_longitude float NULL,
	-- The level 4 of the area (Subdistrict) --
	level_4 VARCHAR NULL,
	-- The latitude of the level 4 of the area --
	level_4_latitude float NULL,
	-- The longitude of the level 4 of the area --
	level_4_longitude float NULL,

	-- Primary key --
	CONSTRAINT area_pkey PRIMARY KEY (id)
);

--- Table 2: farm (plantation) ---
--- This table contains the farms (plantations) ---
CREATE TABLE IF NOT EXISTS  public.farm
(
	-- ID of the farm for internal use --
	id VARCHAR NOT NULL,
	-- ID of the user who owns the farm --
	owner_id VARCHAR NOT NULL,
	-- ID of the area of the farm --
	-- This refers to the area table --
	area_id VARCHAR NOT NULL,
	-- Latitude of the farm --
	latitude float NULL,
	-- Longitude of the farm --
	longitude float NULL,
	-- Area of the farm in hectares --
	area_hectare float NULL,
	-- Year the farm was planted --
	planted_year int NULL,
	-- Month the farm was planted --
	planted_month int NULL,
	-- Number of palm trees per hectare --
	palm_trees_per_hectare int NULL,
	-- Soil type of the farm --
	soil_type VARCHAR NULL,
	-- Seed type of the farm --
	seed_type VARCHAR NULL,

	-- Primary key --
	CONSTRAINT farm_pkey PRIMARY KEY (id),
	-- Foreign key --
	CONSTRAINT fk_farm_area FOREIGN KEY (area_id) REFERENCES public.area(id)
);

--- Table 3: product (plantation) ---
--- This table contains the product catalog of TokoSawit e-commerce ---
CREATE TABLE IF NOT EXISTS public.product(
	-- ID of the product for internal use --
	id VARCHAR NOT NULL,
	-- SKU of the product --
	sku VARCHAR NOT NULL,
	-- Type/category of the product --
	type VARCHAR NOT NULL,
	-- Unit of measurement of the product (e.g. kg) --
	unit_of_measurement VARCHAR NOT NULL,
	-- Name of the product --
	name VARCHAR NOT NULL,
	-- Price of the product in IDR at this moment --
	price DECIMAL NOT NULL,
	-- Description of the product --
	description VARCHAR NOT NULL,

	-- Primary key --
	CONSTRAINT product_pkey PRIMARY KEY (id)
);

-- Table 4: sale_order ---
-- This table contains the sale order of TokoSawit e-commerce --
CREATE TABLE IF NOT EXISTS public.sale_order(
	-- ID of the sale order for internal use --
	id VARCHAR NOT NULL,
	-- ID of the user who made the sale order --
	user_id VARCHAR NOT NULL,
	-- Total price of the sale order at the time of the sale order --
	total_item_price DECIMAL NOT NULL,
	-- Time of the sale order in UTC+0 --
	created_at_utc0 BIGINT NULL,

	-- Primary key --
	CONSTRAINT sale_order_pkey PRIMARY KEY (id)
);

--- Table 5: sale_order_item ---
--- This table contains the item of each of the sale order ---
CREATE TABLE IF NOT EXISTS public.sale_order_item(
	-- ID of the sale order item for internal use --
	id VARCHAR NOT NULL,
	-- ID of the sale order, refers to sale_order table --
	sale_order_id VARCHAR NOT NULL,
	-- ID of the product, refers to product table --
	product_id VARCHAR NOT NULL,
	-- Quantity of the product --
	quantity INT NOT NULL,
	-- Price of the product at the time of sale order --
	price DECIMAL NOT NULL,

	-- Primary key --
	CONSTRAINT sale_order_item_pkey PRIMARY KEY (id),

	-- Foreign key --
	CONSTRAINT fk_sale_order_item_sale_order FOREIGN KEY (sale_order_id) REFERENCES public.sale_order(id),
	CONSTRAINT fk_sale_order_item_product FOREIGN KEY (product_id) REFERENCES public.product(id)
);

-- TRUNCATING
TRUNCATE TABLE public.sale_order_item CASCADE;
TRUNCATE TABLE public.sale_order CASCADE;
TRUNCATE TABLE public.product CASCADE;
TRUNCATE TABLE public.farm CASCADE;
TRUNCATE TABLE public.area CASCADE;

--------------------------------
--- Data ---
--------------------------------

--- Data for area table --
INSERT INTO area (id, name, level_0, level_1, level_2, level_3, level_3_latitude, level_3_longitude, level_4, level_4_latitude, level_4_longitude) VALUES
('ID1101032013', 'Ujung Pasir, Kluet Selatan, Aceh Selatan, Aceh', 'Indonesia', 'Aceh', 'Aceh Selatan', 'Kluet Selatan', 3.05166, 97.45977, 'Ujung Pasir', 3.0791049003601074, 97.32865905761719),
('ID1101142007', 'Pucuk Lembang, Kluet Timur, Aceh Selatan, Aceh', 'Indonesia', 'Aceh', 'Aceh Selatan', 'Kluet Timur', 3.17104, 97.45977, 'Pucuk Lembang', 3.161073684692383, 97.48883819580078),
('ID1102022015', 'Suka Maju, Lawe Sigala-Gala, Aceh Tenggara, Aceh', 'Indonesia', 'Aceh', 'Aceh Tenggara', 'Lawe Sigala-Gala', 3.35698, 97.9266, 'Suka Maju', 3.3567779064178467, 97.93292999267578),
('ID1102032026', 'Terutung Seperai, Bambel, Aceh Tenggara, Aceh', 'Indonesia', 'Aceh', 'Aceh Tenggara', 'Bambel', 3.45716, 97.90482, 'Terutung Seperai', 3.454490900039673, 97.83321380615234),
('ID1205012002', 'Lau Damak, Bahorok, Langkat, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Langkat', 'Bahorok', 3.465967893600464, 98.04651641845703, 'Lau Damak', 3.4722189903259277, 98.09833526611328),
('ID1205012003', 'Timbang Lawan, Bahorok, Langkat, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Langkat', 'Bahorok', 3.465967893600464, 98.04651641845703, 'Timbang Lawan', 3.5087363719940186, 98.08248138427734),
('ID1205012012', 'Simpang Pulo Rambung, Bahorok, Langkat, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Langkat', 'Bahorok', 3.465967893600464, 98.04651641845703, 'Simpang Pulo Rambung', 3.495518207550049, 98.24564361572266),
('ID1205052007', 'Sukamakmur, Binjai, Langkat, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Langkat', 'Binjai', 3.61355, 98.50253, 'Sukamakmur', 3.6853671, 98.45407),
('ID1205201001', 'Sawit Seberang, Sawit Seberang, Langkat, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Langkat', 'Sawit Seberang', 3.80556, 98.24317, 'Sawit Seberang', 3.8087215423583984, 98.28194427490234),
('ID1205202005', 'Sawit Hulu, Sawit Seberang, Langkat, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Langkat', 'Sawit Seberang', 3.80556, 98.24317, 'Sawit Hulu', 3.8472654819488525, 98.21636962890625),
('ID1205202006', 'Mekar Sawit, Sawit Seberang, Langkat, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Langkat', 'Sawit Seberang', 3.80556, 98.24317, 'Mekar Sawit', 3.7936997413635254, 98.2590103149414),
('ID1207242015', 'Kota Datar, Hamparan Perak, Deli Serdang, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Deli Serdang', 'Hamparan Perak', 3.76189, 98.59408, 'Kota Datar', 3.772827625274658, 98.55366516113281),
('ID1209182011', 'Rawa Sari, Aek Kuasan, Asahan, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Asahan', 'Aek Kuasan', 2.66957, 99.71212, 'Rawa Sari', 2.670994520187378, 99.75617980957031),
('ID1209212006', 'Lobu Rappa, Aek Songsongan, Asahan, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Asahan', 'Aek Songsongan', 2.60447, 99.25639, 'Lobu Rappa', 2.580846071243286, 99.43761444091797),
('ID1210092001', 'Lingga Tiga, Bilah Hulu, Labuhan Batu, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu', 'Bilah Hulu', 2.01631, 99.92416, 'Lingga Tiga', 1.9540377, 99.85155929999999),
('ID1220082034', 'Kosik Putih, Simangambat, Padang Lawas Utara, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Padang Lawas Utara', 'Simangambat', 1.53533, 100.12552, 'Kosik Putih', 1.436481237411499, 100.26168060302734),
('ID1222052002', 'Binanga Dua, Silangkitang, Labuhan Batu Selatan, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu Selatan', 'Silangkitang', 1.84276, 99.94651, 'Binanga Dua', 1.8141113, 99.91298450000001),
('ID1222052003', 'Aek Goti, Silangkitang, Labuhan Batu Selatan, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu Selatan', 'Silangkitang', 1.84276, 99.94651, 'Aek Goti', 1.8911841, 99.890643),
('ID1223012005', 'Pulo Dogom, Kualuh Hulu, Labuhan Batu Utara, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu Utara', 'Kualuh Hulu', 2.56197, 99.70098, 'Pulo Dogom', 2.5531164, 99.5784754),
('ID1223032007', 'Sei Apung, Kualuh Hilir, Labuhanbatu Utara, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhanbatu Utara', 'Kualuh Hilir', 2.582491397857666, 100.01322174072266, 'Sei Apung', 2.5934910774230957, 99.96292114257812),
('ID1223052006', 'Pulo Bargot, Marbau, Labuhan Batu Utara, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu Utara', 'Marbau', 2.22967, 99.85714, 'Pulo Bargot', 2.2125582, 99.8766825),
('ID1223052007', 'Sipare Pare Tengah, Marbau, Labuhan Batu Utara, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu Utara', 'Marbau', 2.22967, 99.85714, 'Sipare Pare Tengah', 2.2244749, 99.9073986),
('ID1223052010', 'Belongkut, Marbau, Labuhan Batu Utara, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu Utara', 'Marbau', 2.22967, 99.85714, 'Belongkut', 2.2514443, 99.8655158),
('ID1223052018', 'Sumber Mulyo, Marbau, Labuhan Batu Utara, Sumatera Utara', 'Indonesia', 'Sumatera Utara', 'Labuhan Batu Utara', 'Marbau', 2.22967, 99.85714, 'Sumber Mulyo', 2.1953845, 99.9073986),
('ID1303092002', 'Sisawah, Sumpur Kudus, Sijunjung, Sumatera Barat', 'Indonesia', 'Sumatera Barat', 'Sijunjung', 'Sumpur Kudus', -0.42836, 100.8955, 'Sisawah', -0.5570825934410095, 100.94042205810547),
('ID1401172001', 'Pulau Birandang, Kampa, Kampar, Riau', 'Indonesia', 'Riau', 'Kampar', 'Kampa', 0.35847, 101.19572, 'Pulau Birandang', 0.4331951141357422, 101.19117736816406),
('ID1407131002', 'Rantau Kopar, Rantau Kopar, Rokan Hilir, Riau', 'Indonesia', 'Riau', 'Rokan Hilir', 'Rantau Kopar', 1.39797, 101.00331, 'Rantau Kopar', 1.378489375114441, 101.00445556640625),
('ID1471041002', 'Tanjung Rhu, Limapuluh, Kota Pekanbaru, Riau', 'Indonesia', 'Riau', 'Kota Pekanbaru', 'Limapuluh', 0.53615, 101.45947, 'Tanjung Rhu', 0.5442589999999999, 101.4608895),
('ID1504021002', 'Pasar Muara Tembesi, Muara Tembesi, Batang Hari, Jambi', 'Indonesia', 'Jambi', 'Batang Hari', 'Muara Tembesi', -1.7272, 103.10484, 'Pasar Muara Tembesi', -1.7022965, 103.106286),
('ID1505011003', 'Pijoan, Jambi Luar Kota, Muaro Jambi, Jambi', 'Indonesia', 'Jambi', 'Muaro Jambi', 'Jambi Luar Kota', -1.64887, 103.4743, 'Pijoan', -1.5843608379364014, 103.46379089355469),
('ID1505012007', 'Mendalo Darat, Jambi Luar Kota, Muaro Jambi, Jambi', 'Indonesia', 'Jambi', 'Muaro Jambi', 'Jambi Luar Kota', -1.64887, 103.4743, 'Mendalo Darat', -1.614367127418518, 103.53684997558594),
('ID1507091001', 'Simpang Tuan, Mendahara Ulu, Tanjung Jabung Timur, Jambi', 'Indonesia', 'Jambi', 'Tanjung Jabung Timur', 'Mendahara Ulu', -1.21607, 103.49743, 'Simpang Tuan', -1.2820886373519897, 103.46536254882812),
('ID1508092008', 'Daya Murni, Pelepat Ilir, Bungo, Jambi', 'Indonesia', 'Jambi', 'Bungo', 'Pelepat Ilir', -1.6182, 102.3693, 'Daya Murni', -1.6686439514160156, 102.39576721191406),
('ID1508092011', 'Tirta Mulia, Pelepat Ilir, Bungo, Jambi', 'Indonesia', 'Jambi', 'Bungo', 'Pelepat Ilir', -1.6182, 102.3693, 'Tirta Mulia', -1.6082206, 102.4495221),
('ID1508092014', 'Kuning Gading, Pelepat Ilir, Bungo, Jambi', 'Indonesia', 'Jambi', 'Bungo', 'Pelepat Ilir', -1.6182, 102.3693, 'Kuning Gading', -1.6042186, 102.3292076),
('ID1508121001', 'Sungai Pinang, Bungo Dani, Bungo, Jambi', 'Indonesia', 'Jambi', 'Bungo', 'Bungo Dani', -1.49665, 102.08325, 'Sungai Pinang', -1.4843018054962158, 102.10623931884766),
('ID1509011001', 'Muara Tebo , Tebo Tengah, Tebo, Jambi', 'Indonesia', 'Jambi', 'Tebo', 'Tebo Tengah', -1.52275, 102.48392, 'Muara Tebo ', -1.4922921, 102.4351923),
('ID1601322001', 'Bunglai, Kedaton Peninjauan Raya, Ogan Komering Ulu, Sumatera Selatan', 'Indonesia', 'Sumatera Selatan', 'Ogan Komering Ulu', 'Kedaton Peninjauan Raya', -3.83678, 104.4628, 'Bunglai', -3.8089606761932373, 104.4238510131836),
('ID1674032004', 'Muara Sungai, Cambai, Kota Prabumulih, Sumatera Selatan', 'Indonesia', 'Sumatera Selatan', 'Kota Prabumulih', 'Cambai', -3.38239, 104.29774, 'Muara Sungai', -3.3766634464263916, 104.2431640625),
('ID1709042007', 'Senabah, Pematang Tiga, Bengkulu Tengah, Bengkulu', 'Indonesia', 'Bengkulu', 'Bengkulu Tengah', 'Pematang Tiga', -3.56841, 102.31203, 'Senabah', -3.5822019577026367, 102.22314453125),
('ID1802102003', 'Setia Bumi, Seputih Banyak, Lampung Tengah, Lampung', 'Indonesia', 'Lampung', 'Lampung Tengah', 'Seputih Banyak', -4.86697, 105.48883, 'Setia Bumi', -4.8829915, 105.4478131),
('ID1901042008', 'Kemuja, Mendo Barat, Bangka, Kepulauan Bangka Belitung', 'Indonesia', 'Kepulauan Bangka Belitung', 'Bangka', 'Mendo Barat', -2.1955, 105.8995, 'Kemuja', -2.077556610107422, 105.96820068359375),
('ID1901082004', 'Tanah Bawah, Puding Besar, Bangka, Kepulauan Bangka Belitung', 'Indonesia', 'Kepulauan Bangka Belitung', 'Bangka', 'Puding Besar', -2.04462, 105.85252, 'Tanah Bawah', -2.04725980758667, 105.815185546875),
('ID3173051001', 'Kebon Jeruk, Kebon Jeruk, Kota Adm. Jakarta Barat, Dki Jakarta', 'Indonesia', 'Dki Jakarta', 'Kota Adm. Jakarta Barat', 'Kebon Jeruk', -6.184046745300293, 106.76807403564453, 'Kebon Jeruk', -6.1959421, 106.773595),
('ID3211012006', 'Wado, Wado, Sumedang, Jawa Barat', 'Indonesia', 'Jawa Barat', 'Sumedang', 'Wado', -6.9737, 108.1057, 'Wado', -6.946286201477051, 108.09300231933594),
('ID3529062001', 'Pagarbatu, Saronggi, Sumenep, Jawa Timur', 'Indonesia', 'Jawa Timur', 'Sumenep', 'Saronggi', -7.09777, 113.84658, 'Pagarbatu', -7.129365300000001, 113.8614481);

-- Insert data into farm table --
INSERT INTO public.farm (id, owner_id, area_id, latitude, longitude, area_hectare, planted_year, planted_month, palm_trees_per_hectare, soil_type, seed_type) VALUES
('f02bcded-3b72-43b9-8f14-f7687c4afbd9','145f7e51-c0e9-4dd3-b730-8dd03ee98c3a','ID1223052007',NULL,NULL,1.0,2015,4,125,'Mineral',NULL),
('c18238d1-11ae-43eb-aa16-b9c2d14616dd','f6592c39-68a7-41e3-af84-b79d9a1a5540','ID1223052007',NULL,NULL,1.0,2025,4,125,'Mineral',NULL),
('b519bade-60bf-4781-ba45-6e4803b005c6','4984b691-ed21-4188-b107-cde9bbe65d7f','ID1223052007',NULL,NULL,1.0,2025,4,125,'Mineral',NULL),
('72f4944b-4ca5-40c6-9521-532886a91035','2f8ff664-d15f-44d9-9011-842f646e803f','ID1223052007',NULL,NULL,1.0,2016,4,125,'Mineral',NULL),
('e355222d-1ec6-4a7b-9c0f-516a469b7f91','65df540b-c162-40e5-b806-cef9bd0139d7','ID1223052006',NULL,NULL,1000.25,2010,4,130,'Mineral',NULL),
('f135fdb8-d70f-491c-8389-a3d4729aac68','40ffe78d-33e7-4b78-b792-5c9c094af6ae','ID1223032007',NULL,NULL,5000.0,2010,4,136,'Gambut','Marihat'),
('469ce51e-f55a-44ab-a555-b45ee43cb775','9e91c2b6-3adc-4a5d-8bdb-ea556906ce56','ID1223052007',NULL,NULL,1.0,2025,4,125,'Mineral',NULL),
('9c4bcbc0-e4d1-4f9b-b728-054b8d8868f9','d60d5b00-ed67-42f4-a940-82649eeed33d','ID1209182011',NULL,NULL,140.0,1999,4,136,'Gambut','Socfindo'),
('f3a3e53f-8276-44a8-bc45-114ce1975f15','594d40c4-b677-486b-8871-86781cefacc1','ID1223052007',NULL,NULL,1.0,2014,4,125,'Mineral',NULL),
('1d8f3b64-8a54-424e-aa5d-1a40b50ed11f','666be5a2-5ae9-4fc9-a181-366122b8293a','ID1674032004',-3.3883706287877833,104.24738198518753,10000.0,2023,11,136,'Mineral','Marihat'),
('f1116a5f-66af-4bdf-9534-5530924348b6','31e0cadc-098a-4347-9434-381c127673bd','ID1223052007',NULL,NULL,1.0,2012,4,125,'Mineral',NULL),
('2f396abb-a33b-4fd4-8175-255d77d12d18','f1da67d6-edd1-460f-a398-a91e66bef36f','ID1223052007',NULL,NULL,1.0,2025,4,125,'Mineral',NULL),
('cdd39296-4fc0-4f2d-ae1f-e5dad8c51961','163679f6-716d-49e0-8689-78595e2c7cd5','ID1223052010',NULL,NULL,1000.25,2009,4,130,'Mineral',NULL),
('d7567125-121f-4ebf-bb79-b493dbdb5a3a','3cc77bf5-f355-4ef6-88ac-cb5ed505f243','ID1223052007',NULL,NULL,1.0,2014,4,125,'Mineral',NULL),
('0326f4be-18e1-43e8-b6ca-0405386abfcd','c21cf2ee-c53f-408b-a86d-4d4524fc0f9f','ID1223052007',NULL,NULL,1.0,2011,4,125,'Mineral',NULL),
('771aba41-de50-4933-8a77-341597dcbaab','eeb458f5-98fa-4769-af84-45fdf63341dd','ID1223052007',NULL,NULL,1.0,2015,4,125,'Mineral',NULL),
('8e14e72e-6291-4c73-8a38-a3921fcf5202','0e51e2f0-f302-438c-923a-496f97ffd1ac','ID1223052007',NULL,NULL,1.0,2017,4,125,'Mineral',NULL),
('19da1acb-7040-49c0-8c92-cd81ba0923b2','6232413f-c9cd-4af5-9994-ec6985d762e9','ID1223052007',NULL,NULL,1.0,2025,4,125,'Mineral',NULL),
('8c8bb250-ed33-424f-b82f-3f0366aa8a88','120855fa-20be-4bc2-aea3-ee95c61ddb1e','ID1508121001',NULL,NULL,2.0,2021,4,130,'Mineral','Simalungun'),
('31d3175e-05a1-4e62-ad79-8c56925ca018','1cb72d59-a2b4-4287-a207-b623d13485e7','ID1303092002',NULL,NULL,9750.0,2025,4,136,'Mineral Berpasir','Sriwijaya'),
('1b756ea6-690b-478c-bad8-eff4f9e03301','8abb9720-280e-42b7-97d1-57b47e4c7f6f','ID1210092001',NULL,NULL,2.0,2010,4,120,'Mineral','Merek Bibit Lainnya'),
('f9896038-ddeb-4a63-bfb5-bfc35f9accd0','5adfd8d9-7a11-455b-90e8-62d22eb4fe91','ID1101032013',NULL,NULL,1.0,2025,4,4,'Mineral','SEM'),
('b61a9182-e109-42e3-8556-c22f4c88dab0','8c0e41e7-7a5f-4ff1-b42e-55aa219441d3','ID1101032013',NULL,NULL,1.0,2025,4,NULL,'Mineral','Dami Mas'),
('7ef8ff31-5b8a-4aac-a10b-b8da9db6c13a','6052d8b9-bcf8-4313-89c7-b80b286f5e23','ID1508092008',NULL,NULL,2.0,2014,2,240,'Mineral','Simalungun'),
('0b62cc9e-a26d-40d5-a5d6-537f83e8fcc9','1078ef21-01f0-47a5-8fe0-877d444ddae7','ID1601322001',0.51044008681706,101.43830884248018,5.0,2021,3,984,'Gambut','Sriwijaya'),
('c93fa385-dd57-4480-b840-389a976475d9','7fc3252f-cb74-4d6e-9c5e-7e385c951da5','ID1407131002',NULL,NULL,2.0,2010,4,260,'Gambut','Marihat'),
('c346f3ac-7e2a-47e5-a3d6-b1bab2103dfd','89aa04ac-69d6-4181-aa0d-3e40a26daf07','ID1509011001',NULL,NULL,1000.25,2024,4,136,'Gambut',NULL),
('7ca1e2b3-618d-4012-9569-8cf878a71160','60159ed0-bd11-4bec-a351-8c7e45ed4d94','ID1901082004',NULL,NULL,2500.0,2023,4,250,'Mineral','Merek Bibit Lainnya'),
('8654a203-5880-4b3c-b432-a34204474ef8','e45dbbdd-0788-4fbe-8124-686b871f9af4','ID1901042008',NULL,NULL,1.5,2024,7,146,'Mineral','Topaz'),
('dd1ebec4-07d1-42cb-90e8-21c30d735aaf','eea144f4-626e-4234-b986-99984b3522a2','ID1709042007',NULL,NULL,5.0,2020,12,575,'Mineral','Simalungun'),
('199abcb2-6a40-4174-b86a-9cbefa4bb996','d8379c23-1136-4732-874b-abc52a632f15','ID1223032007',NULL,NULL,5000.0,2010,4,136,'Gambut','Lonsum'),
('009a8b36-64dc-483d-9868-6522f4157759','f9fa8b4e-f362-453f-b39e-e7f21a438a45','ID1223052018',NULL,NULL,1.5,2003,4,190,'Mineral',NULL),
('66f6de09-baf0-41ab-b4ff-b27898c52807','f56fdd36-9774-45be-8c84-6228853c038a','ID1223032007',NULL,NULL,1000.25,2012,4,135,'Gambut','Marihat'),
('504df8c2-a468-4b79-95ab-7c18e3847921','01f5b78c-17d8-4e4f-a75c-123c224f64f3','ID1209212006',NULL,NULL,4.0,2015,7,NULL,'Mineral',NULL),
('6d2d0089-0461-4ad2-bc7c-c666c408924f','b5661567-4b0a-4144-9409-131607855e03','ID1508092011',NULL,NULL,4.0,2025,1,140,'Mineral','Merek Bibit Lainnya'),
('4254e0b0-5ca0-4379-a69c-21e0088987b7','4a21d70f-2978-48f9-8ac8-3a06a1f736d9','ID1205012002',NULL,NULL,1.0,2018,2,NULL,'Mineral',NULL),
('5a57f58f-f2ab-4f02-a89c-2b16c7752cf4','4b2c213b-3619-4951-9eb0-19e4c2ce84b9','ID1207242015',NULL,NULL,1.0,2010,9,NULL,'Mineral',NULL),
('96ee771f-662d-4057-9483-30c3f4255f80','fb641fee-766f-4ea4-b0f4-7b7651415ccc','ID1205201001',NULL,NULL,0.6000000238418579,2018,8,NULL,'Mineral',NULL),
('b9b53cd8-b1a9-4ff0-8e22-a2770639d25d','f3866bef-84d6-4fdd-95fe-e9971f3b7afc','ID1207242015',NULL,NULL,1.0,2011,1,NULL,'Mineral',NULL),
('d231eb01-bc2c-46a6-a69a-adfb3c22988e','19d2c440-c133-49a9-9f42-de81b4938449','ID1101142007',NULL,NULL,3000.0,2018,4,120,'Mineral','Socfindo'),
('e8f0b120-0da3-4c76-8abf-949105818c3d','23a9a6fe-e5af-4d8a-a733-29a5a5fa6fe0','ID1205202005',NULL,NULL,0.6000000238418579,2016,9,NULL,'Mineral',NULL),
('c0a2c847-15be-479e-a6e5-f9c2521d03b2','3201c9f3-df3a-4e32-bd05-1b79400f3545','ID1207242015',NULL,NULL,1.0,2016,1,NULL,'Mineral',NULL),
('bb528a01-1ae8-4ef1-947f-b76b1e3dae73','c1cbca7b-3528-4192-b9d2-0724324e6e7b','ID1505011003',NULL,NULL,100.0999984741211,2022,6,130,'Mineral',NULL),
('71c2540c-03bc-4d52-b418-a651ea4bce19','91144a67-8b6e-4921-a3e1-774670be8e79','ID1207242015',NULL,NULL,0.699999988079071,2017,8,NULL,'Mineral',NULL),
('98966e18-2de2-49ea-8045-63efed3108d7','9ae07fa8-ced2-4a83-bf3f-11fa0d82885b','ID1207242015',NULL,NULL,1.0,2013,6,NULL,'Mineral',NULL),
('6ed64e09-c7cd-4796-9fb3-fa4af066681a','c97cea97-9fe2-4f12-8535-e40182cba737','ID1205202005',NULL,NULL,0.5,2017,7,NULL,'Mineral',NULL),
('4d9f97a4-c939-445c-87cc-ef66cb453968','4a21d70f-2978-48f9-8ac8-3a06a1f736d9','ID1207242015',NULL,NULL,1.0,2011,4,NULL,'Mineral',NULL),
('d1d25420-c164-421a-912e-fa4fb246eee2','7e4de766-a9cd-48ad-a93e-557caf298bd0','ID1205202006',NULL,NULL,2.0,2019,4,NULL,'Mineral',NULL),
('73c3a2a9-9740-409f-ae1a-a3f47373d5c6','06e2e9a3-0897-441b-8993-d2d36a2d5397','ID1223032007',NULL,NULL,1000.25,2010,4,135,'Gambut',NULL),
('92231464-22f6-4727-8b53-cf2850d872d6','f2597b6f-877e-4706-8a8e-bad993b6d537','ID1205202006',NULL,NULL,1.0,2017,7,NULL,'Mineral',NULL),
('e62285fa-19fa-417f-934c-7d2928a1a443','e9650f87-4f8a-488c-9883-4425ce03c7e8','ID1207242015',NULL,NULL,1.0,2013,6,NULL,'Mineral',NULL),
('ac5e1715-333a-438e-a4a0-c133db32497e','cdb24ec2-94bd-4777-9e50-464fb9be4869','ID1207242015',NULL,NULL,1.0,2013,2,NULL,'Mineral',NULL),
('9f2c0c5b-f6ac-442c-820d-c010e1a5d2d3','b3619c9b-7e52-4d6c-a28e-01187aad04c2','ID1205202006',NULL,NULL,2.0,2019,4,NULL,'Mineral',NULL),
('1b9ba6dc-6907-422e-9a35-68f556904924','941f27f1-c4c5-43ae-b3cd-dbc1cd4e3d52','ID1205202005',NULL,NULL,1.0,2016,9,NULL,'Mineral',NULL),
('3364da64-fccd-46f7-8436-e73f2669672a','af8cfce4-e5b3-4ee1-957a-c969aa4773a7','ID1205202005',NULL,NULL,0.699999988079071,2017,11,NULL,'Mineral',NULL),
('1e77d6ef-4c37-40e3-b9ee-a570481425b4','d041e44b-02bc-4922-9119-d64068e6ec15','ID1507091001',NULL,NULL,5.0,2004,4,136,'Gambut','Marihat'),
('732566a8-2e59-46b8-a9e0-aac7336f476e','f3ad5d3b-3c5c-4616-b122-148750970462','ID1205052007',NULL,NULL,1.0,2009,5,NULL,'Mineral',NULL),
('d6cf4a39-f59e-4071-9a72-0e4b74caaea8','f9f73982-5ed5-47e0-a069-ae9754f6c228','ID1220082034',NULL,NULL,3.0,2000,4,375,'Mineral',NULL),
('fb04a77a-6eac-4278-bab4-5356f6135700','4eaac51c-d8b8-4771-a5cc-2889e9f34f82','ID1205202006',NULL,NULL,3.0,2019,4,NULL,'Mineral',NULL),
('17afcc9b-9a25-4f0e-87e1-b882c9f1edad','0177b389-021a-4dac-8f63-20ec65f8cb2c','ID1205202006',NULL,NULL,2.0,2020,4,NULL,'Mineral',NULL),
('52751193-70f8-40f4-834f-5631551a81c4','00529eeb-ff1e-4198-85a1-00a345bcbadb','ID1205202005',NULL,NULL,0.5,2019,6,NULL,'Mineral',NULL),
('9828db73-0094-41fd-93b3-bf4262800016','c5dce376-15ff-4d52-8ead-7aff0eee8f2c','ID1205202005',NULL,NULL,0.800000011920929,2015,8,NULL,'Mineral',NULL),
('b05b21ee-3390-4835-83d6-10266e2ea64a','33fd380e-560c-49b2-9197-1c4a6d88e24e','ID1205202005',NULL,NULL,1.0,2018,7,NULL,'Mineral',NULL),
('3ab8ac52-b23a-4ceb-a6b9-5614286727a4','7b541186-c924-4eb2-9f70-3c9488879121','ID1205202006',NULL,NULL,2.0,2020,4,NULL,'Mineral',NULL),
('e6287434-4ea2-4787-bd73-6915e213c8d9','fd949286-2d5d-4826-a038-57a845ddd0cc','ID3211012006',NULL,NULL,1000.0,2010,2,1,'Mineral',NULL),
('6d9d6b4e-032c-4418-9155-dd9a7a3090bf','65333dbe-b406-4200-b230-87747c9bc349','ID1207242015',NULL,NULL,0.5,2017,7,NULL,'Mineral',NULL),
('05e3a2b1-3d88-4198-ba2e-fc9ed7e4caa0','40069cfe-8d76-4cf5-ac95-35c273a30ea8','ID1504021002',NULL,NULL,2.0,2019,4,130,'Mineral','Socfindo'),
('e8f3471c-c629-47da-a63f-1b1822bf7d7e','d8a06b81-9a6b-4cff-a351-bc615b78624e','ID1205202005',NULL,NULL,0.5,2015,7,NULL,'Mineral',NULL),
('9f76a5af-7b7b-4612-90ee-b8e16f9a6474','dde0e601-583c-47e2-a4c7-33195eeb4158','ID1223032007',NULL,NULL,1000.25,2015,4,135,'Gambut',NULL),
('08eef3ae-0d4f-4197-a2f6-6edfa30db3e0','e35d813c-58e7-464e-b323-9d331f1e151e','ID1222052003',NULL,NULL,1.0,2010,4,140,'Mineral Berpasir','Simalungun'),
('bb419e91-d722-4a08-a507-6139dc541919','40069cfe-8d76-4cf5-ac95-35c273a30ea8','ID1505012007',NULL,NULL,2.0,2024,4,130,'Mineral','Topaz'),
('111ba4a7-8ce4-4095-b7af-5cafabbf4150','a8ae22ef-a544-41aa-887c-688b5a4a55f1','ID1205202005',NULL,NULL,0.5,2016,10,NULL,'Mineral',NULL),
('d483e6ac-3fac-4ce8-b13e-5aac525e64eb','946160f0-a83e-469c-9386-db1bfc85b931','ID1205052007',NULL,NULL,1.0,2009,5,1,'Mineral','Merek Bibit Lainnya'),
('63e787df-d440-497b-a345-10133232aa65','bd9ff00a-8b99-47a3-92d7-e4725a40ffc0','ID1508092014',NULL,NULL,1.0,2018,4,140,'Mineral','Marihat'),
('fa76c9c9-ebab-4759-aace-26718630269f','fd949286-2d5d-4826-a038-57a845ddd0cc','ID3529062001',NULL,NULL,2.0,2009,4,NULL,'Mineral',NULL),
('437566e9-7c4d-4664-941f-6a2684407020','46ed48e4-cf7d-4d2a-92b0-6b80112a30a7','ID1205202005',NULL,NULL,0.699999988079071,2014,9,NULL,'Mineral',NULL),
('b9e2506a-ad08-412c-8913-a9eee9c47e36','2194a00f-419b-4aaf-9487-c824852c6368','ID1802102003',NULL,NULL,1.0,2012,7,NULL,'Mineral','ASD-Bakrie'),
('7df7c9b6-555e-470c-8e19-2e9da8c03017','a52d5374-ad6d-4d08-b55a-9f78d10481f3','ID1205202005',NULL,NULL,0.5,2017,8,NULL,'Mineral',NULL),
('839d1a16-9040-4f65-ae23-0c72d30be404','32d0a938-00b3-4950-89f3-3eec014a3090','ID1205202006',NULL,NULL,2.0,2021,4,NULL,'Mineral',NULL),
('8458760c-d87d-4c4d-bc30-60966dd3fdef','ee79f9d5-9606-4dc7-8fe2-7f0472577e07','ID1205201001',NULL,NULL,2.0,2021,4,NULL,'Mineral',NULL),
('1a50ff31-ce6f-4688-a044-be52ed99e9fc','e28e0345-dbad-4910-8784-2da31bf70ab9','ID1205202005',NULL,NULL,0.5,2019,6,NULL,'Mineral',NULL),
('e7a8893a-e765-437a-a5d9-838274ee2419','dfa538d5-12f4-4a1f-b4e5-fadf961f9c36','ID1102022015',NULL,NULL,1.0,2009,5,NULL,'Mineral',NULL),
('f809c9e4-7eed-4e9d-b693-c134071e6448','e82487d9-ad22-43c2-9085-f298e70d07bf','ID1223012005',NULL,NULL,10000.0,2010,2,500,'Mineral','Lonsum'),
('1e59eb6f-03df-479d-a0b2-31941b0efb73','5e8c51e6-d476-43f0-9745-addeb2a492ba','ID1205202005',NULL,NULL,0.5,2015,8,NULL,'Mineral',NULL),
('9d1db659-5cf1-4186-ad8f-d9ad12a39478','e8ba87e8-5227-4584-8fa2-bd02ddc8673d','ID1205202005',NULL,NULL,1.0,2018,4,NULL,'Mineral',NULL),
('fd5cd482-574a-494c-947b-db33c9b0be93','744be73c-5b43-4118-bb6c-28ff9341c699','ID1205202006',NULL,NULL,2.0,2019,4,NULL,'Mineral',NULL),
('52afad77-2072-4088-905f-2e409e778109','00e2e2ca-d9f6-4678-8985-e1f97b254651','ID1205201001',NULL,NULL,2.0,2020,4,NULL,'Mineral',NULL),
('90a08451-597b-4fea-b6a3-c739df8c2bfa','e61a8906-d506-46ad-ae27-ba60d17c81f3','ID1401172001',NULL,NULL,120.0,2019,1,125,'Mineral','Topaz'),
('e7fe2fa3-7ed3-4d3d-a2de-909ddbb389be','62bfb19d-4bd3-448f-83ed-121151624e82','ID1205202005',NULL,NULL,1.0,2016,9,NULL,'Mineral',NULL),
('b2791c35-814a-4caf-b87c-d1d11eb47174','981e225b-a9c2-4ef2-ba00-44a679d63620','ID1205012003',NULL,NULL,1.0,2019,9,NULL,'Mineral',NULL),
('c0726c5d-b1a5-412f-aff5-e3b954fb37ab','bb9f7889-5666-42c0-8ec2-42be3617b67d','ID1205012003',NULL,NULL,0.6000000238418579,2019,9,NULL,'Mineral',NULL),
('f6bf4faa-62e9-4ea8-89c0-79d6d7f419ad','57939796-0dac-4c3c-a1eb-26b4d5ccf3db','ID1471041002',NULL,NULL,2.0,2025,4,NULL,'Mineral',NULL),
('b8b4129d-4fbb-4a31-bd70-6548f16a8d75','c11ca388-9e28-49d1-800e-ee4f61d95b19','ID1102032026',NULL,NULL,1.0,2009,3,NULL,'Mineral',NULL),
('3ca4e09c-a0dc-42bc-9603-066b79c0dcea','fcd46b68-4a89-468f-bbc2-35aeb7e0e378','ID1205012012',NULL,NULL,1.0,2018,9,NULL,'Mineral',NULL),
('6807037a-f75c-4f34-9814-5b19e59c0d4a','6ff1149e-cd24-40f7-8170-37cfe02aafb0','ID1102022015',NULL,NULL,2.0,2009,5,NULL,'Mineral',NULL),
('94ebefb5-9fd8-4256-9f85-9f471f787998','66fe3faa-8bf9-4734-b138-0d09e72d6fd3','ID1205012003',NULL,NULL,0.6000000238418579,2021,6,NULL,'Mineral',NULL),
('ab0d8cfa-67a1-4098-9d82-cc1daac86242','0be24850-8764-48ba-9714-da88a2a4f6a2','ID3173051001',NULL,NULL,1.0,2009,5,NULL,'Mineral',NULL),
('755b6ca2-69c0-4e87-9a22-9399d39f962e','3df545b2-f9b7-4e22-a2a4-4d36101e8b85','ID1205012003',NULL,NULL,0.5,2018,10,NULL,'Mineral',NULL),
('afb24173-bbec-4595-878b-c9acff5bc505','a1a124d7-f279-4b58-997c-aac3835859d4','ID1222052002',NULL,NULL,1.5,2010,4,200,'Mineral','Marihat'),
('069976d1-008e-4f2d-92d7-65ae30f6ea7c','ce306f6d-c595-43ec-817e-f4600513e9fe','ID1205012003',NULL,NULL,0.5699999928474426,2017,10,NULL,'Mineral',NULL);

-- Data for the product table ---
INSERT INTO product (id, sku, type, name, unit_of_measurement, price, description) VALUES
('beb17fe4-5d92-4738-adaa-2d62ffb83516', '101110503802', 'GOODS', 'Urea Nitrea 46% N 50kg - Granul', 'kg', 356357, '<p>Urea Nitrea 46% N 50kg Granul</p>'),
('b67588d2-e8fe-4ee4-9931-e9d18241d04c', '202310305001', 'GOODS', 'PRIMASTAR 300/100 SL 5 liter', 'kg', 230000, '<h2 class="ql-align-justify"><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);">PRIMASTAR 300/100 SL : Herbisida sistemik purna tumbuh berbentuk larutan dalam air untuk mengendalikan gulma berdaun lebar dan gulma golongan rumput pada pertanaman kelapa sawit (TBM)</span></h2><p><br></p><h2><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);">Bahan Aktif : Isopropil Amina Glifosat 300 g/l + 2,4-D Dimetil Amina 100 g/l</span></h2><p><br></p><h2 class="ql-align-center"><span style="background-color: rgb(8, 18, 138); color: rgb(255, 255, 255);">Cara & Waktu Aplikasi</span></h2><p><br></p><h2><span style="background-color: rgb(255, 255, 255); color: rgb(0, 0, 0);">Penyemprotan volume tinggi dengan volume 400 - 600 l/ha. Aplikasi dimulai saat gulma tumbuh subur dan tidak turun hujan 4 - 6 jam setelah penyemprotan. Apabila belum jelas hubungi petugas pertanian yang berwenang</span></h2><p><br></p>'),
('c5e57af4-0df9-4e2b-87e4-9024b8e6cf53', '202310304901', 'GOODS', 'DMA 6 825 SL 400ml', 'kg', 97000, '<p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">DMA6 825 SL</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Berat bersih: 400ml</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Bahan aktif: 2,4-D dimetil amina (setara dengan 2,4-D: 686 g/l) : 825 g/l</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Produksi : Corteva Agriscience</span></p><p><br></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">DMA6 825 SL</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Herbisida sistemik selektif purna tumbuh yang berbentuk larutan dalam air berwarna coklat muda,sangat efektif untuk mengendalikan gulma di pertanaman padi, karet, teh dan tebu.</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Herbisida ini sudah tidak diragukan untuk tanaman padi sawah. yang berguna menberantas gulma daun lebar (Broadleaf) and teki tekian di sawah. juga sangat bagus untuk campuran ke glyphosate dan paraquat.</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Dapat digunakan pada tanaman: karet, padi, tebu, teh</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Herbisida sistemik purna tumbuh berbentuk larutan dalam air.</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Dosis :</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">– Karet (Gulma Berdaun Lebar) : 1,5 – 3 l/Ha</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Waktu Penyemprotan : Pada saat gulma masih muda dan aktif pertumbuhannya</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">– Teh (Gulma Berdaun Lebar) : 1 – 1,5 l/Ha</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Waktu Penyemprotan : Pada saat gulma masih muda dan aktif pertumbuhannya</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">– Tebu (Gulma Berdaun Lebar) : 1 – 2 l/Ha</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Waktu Penyemprotan : Segera setelah tanam, atau 3 hari setelah tanam atau 14 hari setelah tanam</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">– Padi (Gulma Berdaun Lebar dan Teki) : 1 – 1,5 l/Ha</span></p><p><span style="background-color: rgb(249, 249, 249); color: rgb(119, 119, 119);">Waktu Penyemprotan : 14 hari setelah tanam saat gulma sedang tumbuh</span></p><p><br></p>'),
('487f2886-5150-4269-94e2-63fbc7314971', 'SEEDLING-TOPAS-MAIN-NURSERY', 'GOODS', 'Bibit Topaz Siap Tanam', 'kg', 45100, ''),
('8152e395-0f7a-4dda-8df9-6655a726c4e1', '101210600103', 'GOODS', 'Pupuk SawitPRO 20kg + Abu Janjang 40kg', 'kg', 1080000, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk SawitPRO adalah pupuk organik yang dapat membantu petani kelapa sawit meningkatkan hasil panen dan kualitas buah. Pupuk ini dilengkapi dengan mikroorganisme yang dikembangkan oleh pakar biologi terkemuka di Indonesia. Mikroorganisme dapat dimanfaatkan untuk membantu penguraian hara dan percepatan dari penyerapan hara pada tanaman.</p><p><br></p><p>Abu Janjang adalah pupuk organik dengan kandungan K₂O tinggi, sekitar 35%–45%, yang cepat diserap tanaman karena hanya mengandung unsur kalium. Untuk aplikasi, dosis yang dianjurkan adalah 1,5 kg per tanaman. Jika digunakan bersama Pupuk SawitPRO, rekomendasi dosisnya adalah 1 kg Abu Janjang dan 0,5 kg SawitPRO per tanaman.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk SawitPRO memberikan berbagai manfaat penting, termasuk meningkatkan ketersediaan unsur hara (nitrogen, fosfat, dan kalium), serta membantu perombakan bahan organik (dekomposisi) dan mineralisasi unsur organik. Pupuk ini juga memicu pertumbuhan tanaman, melindungi akar dari mikroba patogen, meningkatkan efisiensi penyerapan dari pupuk lain (RP, Urea, dll.), dan menghemat biaya pemupukan hingga 50%. Selain itu, Pupuk SawitPRO meningkatkan daya tahan tanaman terhadap serangan penyakit dan menjaga kesuburan tanah untuk pertanian berkelanjutan.</p><p><br></p><p>Abu Janjang meningkatkan ketersediaan kalium (K), merangsang pertumbuhan buah, mempercepat dekomposisi bahan organik, dan menghemat biaya pemupukan. Selain itu, produk ini memperkuat daya tahan tanaman terhadap penyakit dan mendukung kesuburan tanah untuk pertanian berkelanjutan.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Pupuk SawitPRO 20kg:</p><p>Nitrogen 0,1-1% Nitrogen</p><p>Fosfor pentoksida 3-5%</p><p>Kalium Oksida 17-25%</p><p>Bakteri pengikat nitrogen</p><p>Trichoderma</p><p><br></p><p>Mikroorganisme:</p><p>Rhizobium sp (bakteri pengikat nitrogen pada legume akar)</p><p>Azotobacter sp (bakteri pengikat nitrogen dari udara bebas)</p><p>Streptomyces sp (penghasil antibiotik dan enzim auksin)</p><p>Bacillus sp (melawan patogen dan mendorong pertumbuhan)</p><p>Azospirillum sp (mendorong pertumbuhan)</p><p>Pseudomonas sp (zat pengatur pertumbuhan)</p><p>Trichoderma sp (zat pengontrol hayati terhadap serang jamur khususnya Ganoderma)</p><p><br></p><p>Abu Janjang 40kg:</p><p>Kalium Oksida 35-45%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em></strong> Ya</p>'),
('4698d965-a133-4701-838b-f60e38c66b39', '101210600102', 'GOODS', 'Pupuk SawitPRO 50kg + Abu Janjang 40kg', 'kg', 1399999, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk SawitPRO adalah pupuk organik yang dapat membantu petani kelapa sawit meningkatkan hasil panen dan kualitas buah. Pupuk ini dilengkapi dengan mikroorganisme yang dikembangkan oleh pakar biologi terkemuka di Indonesia. Mikroorganisme dapat dimanfaatkan untuk membantu penguraian hara dan percepatan dari penyerapan hara pada tanaman.</p><p><br></p><p>Abu Janjang adalah pupuk organik dengan kandungan K₂O tinggi, sekitar 35%–45%, yang cepat diserap tanaman karena hanya mengandung unsur kalium. Untuk aplikasi, dosis yang dianjurkan adalah 1,5 kg per tanaman. Jika digunakan bersama Pupuk SawitPRO, rekomendasi dosisnya adalah 1 kg Abu Janjang dan 0,5 kg SawitPRO per tanaman.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk SawitPRO memberikan berbagai manfaat penting, termasuk meningkatkan ketersediaan unsur hara (nitrogen, fosfat, dan kalium), serta membantu perombakan bahan organik (dekomposisi) dan mineralisasi unsur organik. Pupuk ini juga memicu pertumbuhan tanaman, melindungi akar dari mikroba patogen, meningkatkan efisiensi penyerapan dari pupuk lain (RP, Urea, dll.), dan menghemat biaya pemupukan hingga 50%. Selain itu, Pupuk SawitPRO meningkatkan daya tahan tanaman terhadap serangan penyakit dan menjaga kesuburan tanah untuk pertanian berkelanjutan.</p><p><br></p><p>Abu Janjang meningkatkan ketersediaan kalium (K), merangsang pertumbuhan buah, mempercepat dekomposisi bahan organik, dan menghemat biaya pemupukan. Selain itu, produk ini memperkuat daya tahan tanaman terhadap penyakit dan mendukung kesuburan tanah untuk pertanian berkelanjutan.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Pupuk SawitPRO 50kg:</p><p>Nitrogen 0,1-1% Nitrogen</p><p>Fosfor pentoksida 3-5%</p><p>Kalium Oksida 17-25%</p><p>Bakteri pengikat nitrogen</p><p>Trichoderma</p><p><br></p><p>Mikroorganisme:</p><p>Rhizobium sp (bakteri pengikat nitrogen pada legume akar)</p><p>Azotobacter sp (bakteri pengikat nitrogen dari udara bebas)</p><p>Streptomyces sp (penghasil antibiotik dan enzim auksin)</p><p>Bacillus sp (melawan patogen dan mendorong pertumbuhan)</p><p>Azospirillum sp (mendorong pertumbuhan)</p><p>Pseudomonas sp (zat pengatur pertumbuhan)</p><p>Trichoderma sp (zat pengontrol hayati terhadap serang jamur khususnya Ganoderma)</p><p><br></p><p>Abu Janjang 40kg:</p><p>Kalium Oksida 35-45%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em></strong> Ya</p>'),
('2b8fe2f0-5d07-459c-8781-22305a61980a', '101110507601', 'GOODS', 'Dolomit Super Inti M-100 50kg', 'kg', 65000, '<p>Dolomit Super Inti M-100</p>'),
('c1d06ac3-5bea-4b4d-8648-ae3fa531f059', 'REPORT-REQUEST-MILL-1', 'SERVICE', 'Paket Laporan Pengiriman', 'kg', 50000, 'Paket Laporan Pengiriman untuk 1 Pabrik Rekanan SawitPRO <p>-</p>'),
('0bd2430a-6613-442a-9d5a-11d64cb095ae', 'MERCH-SAWITPRO-SHIRT-02', 'GOODS', 'Kaos SIBRONDOL SawitPRO size XL', 'kg', 100000, '<p>Kaos tidak berkerah warna Putih bertuliskan "Sibrondol SawitPRO".</p><p>Ukuran All-size (XL)</p>'),
('d3999f4e-890a-473f-bb92-2fd2178da3fb', '101110607001', 'GOODS', 'NPK DGW 13-6-27 50kg', 'kg', 760000, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk NPK dari DGW diformulasikan secara khusus untuk penanaman sawit. Formulanya yang kaya fosfor dan kalium sangat sesuai untuk lahan-lahan mineral yang memiliki kandungan rendah dari kedua unsur tersebut.</p><p><br></p><p>Bentuk / Warna: Granul / Coklat</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk dengan teknologi Compaction ini memastikan kandungan unsur hara yang terjamin, mengandung berbagai unsur makro dan mikro esensial untuk mendukung pertumbuhan tanaman secara optimal.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 13%</p><p>Fosfor pentoksida 6%</p><p>Kalium oksida 27%</p><p>Magnesium oksida</p><p>Boron</p><p>Kalsium oksida</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em><u> </u></strong>Ya</p>'),
('2485b082-5258-44c1-b6aa-983387d540a7', '202320303701', 'GOODS', 'Batara 135 SL - 1 Liter', 'kg', 86000, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Batara 135 SL adalah herbisida pasca tumbuh yang bekerja secara kontak, berbentuk larutan berwarna hijau tua yang larut dalam air.</p><p><br></p><p>Bentuk: Larutan</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Produk ini efektif mengendalikan gulma pada tanaman kelapa sawit, karet, jagung, padi TOT, kakao, serta pada lahan kosong.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Parakuat diklorida 13,5 %</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('76fddc47-aea9-4942-9dbd-19d90f31cdd4', '202320303801', 'GOODS', 'Marxone 300 SL - 5 Liter', 'kg', 499700, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>MARXONE 300 SL adalah herbisida kontak purna tumbuh berbentuk larutan hijau tua yang mengandung Parakuat diklorida 300 g/l, efektif untuk mengendalikan berbagai gulma berdaun lebar dan sempit pada tanaman jagung, karet TBM, dan kelapa sawit TBM. Produk ini bekerja cepat, aman untuk tanaman sekitar, dan ideal digunakan pada gulma yang tumbuh aktif dengan dosis bervariasi antara 1–3 liter per hektar tergantung jenis tanaman.</p><p><br></p><p>Bentuk / Warna: Larutan / Hijau tua</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Produk ini efektif digunakan untuk mengendalikan gulma pada tanaman jagung, karet (TBM), dan kelapa sawit (TBM).</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Parakuat diklorida 30%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('701928af-24e9-4a13-aaad-63ede44be9c8', '202320304701', 'GOODS', 'Bom Up 520 SL - 5 Liter', 'kg', 502645, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>BOM UP 520 SL adalah herbisida sistemik pasca tumbuh yang berbentuk larutan berwarna kuning terang, dirancang untuk mengendalikan gulma pada tanaman kelapa sawit, teh, dan karet dalam fase belum menghasilkan (TBM). Herbisida ini dilengkapi dengan Teknologi BIOSORB, yang memungkinkan bahan aktif tetap efektif meskipun terkena hujan, dengan daya tahan 1 hingga 2 jam setelah aplikasi. Hal ini menghilangkan kebutuhan untuk penyemprotan ulang sehingga lebih praktis dan efisien.</p><p><br></p><p>Bentuk / Warna: Larutan / Kuning terang</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>BOM UP 520 SL efektif digunakan untuk mengendalikan berbagai jenis gulma, baik berdaun lebar maupun berdaun sempit. Untuk gulma berdaun lebar, herbisida ini efektif pada jenis seperti Asystasia intrusa, Ageratum conyzoides, dan Borreria alata. Sementara itu, untuk gulma berdaun sempit, produk ini mampu mengatasi jenis seperti Axonopus compressus, Ottochloa nodosa, Paspalum conjugatum, dan Ischaemum timorense. Kemampuan ini menjadikannya solusi andal untuk pengendalian gulma yang beragam.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Isopropil amina (IPA) glifosat 52%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('369cfbc5-f536-41f5-8a80-267d55dec802', '101110506601', 'GOODS', 'Kieserite SoluMAG-G 50kg', 'kg', 435892, 'SoluMAG-G® merupakan pupuk Magnesium berbasis Sulfur yang dikhususkan untuk menyeimbangkan unsur hara dalam sistem pertanian intensif yang bertujuan untuk mendapatkan produktivitas dan kualitas produksi yang tinggi.\n\nPupuk SoluMAG-G® berkualitas untuk hasil produksi Tandan Buah Segar (TBS) dan rendemen minyak sawit yang lebih tinggi.\n\nPupuk SoluMAG-G® mengandung unsur hara Magne- sim dan Sulfur dalam bentuk tersedia segera bagi tanaman <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Kieserite (magnesium sulfat) adalah pupuk yang kaya akan magnesium dan belerang, cocok untuk hampir semua jenis tanaman dan tanah. Cepat larut dan bereaksi efektif, Kieserite ideal untuk memenuhi kebutuhan magnesium tanaman, baik sebelum penanaman atau selama pertumbuhan. Pupuk ini dapat diaplikasikan langsung ke tanah dalam bentuk bubuk atau granular dan dapat diproses menjadi garam Epsom untuk aplikasi irigasi.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Tanah dengan pH rendah, seperti tanah berpasir, membutuhkan tambahan unsur hara ini untuk mendukung pertumbuhan tanaman. Dalam kondisi seperti ini, pemupukan menggunakan Kieserite sangat diperlukan. Sementara itu, tanah di daerah tropis yang berlempung umumnya sudah memiliki kandungan magnesium yang cukup dan jarang mengalami pencucian hara magnesium oleh air.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Magnesium oksida 27%</p><p>Sulfur 17%</p><p>Bentuk / Warna : Tepung / Abu-abu keputihan</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('6eccf249-a997-4091-8d64-29f1e9accd85', '202320303001', 'GOODS', 'Metsulindo 20 WP - 250gr', 'kg', 106200, 'Metsulindo 20 WP - 250gr <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Herbisida selektif sistemik, yang dapat digunakan pada tahap pra-tumbuh dan purna-tumbuh, berbentuk tepung yang dapat disuspensikan berwarna putih hingga krem, efektif untuk mengendalikan pakis-pakisan di hutan tanaman industri, gulma berdaun lebar pada tanaman kelapa sawit (TBM) dan karet (TBM), serta gulma berdaun lebar, sempit, dan teki pada tanaman padi sawah.</p><p><br></p><p>Bentuk / Warna: Tepung / Putih krem</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Metsulindo 20 WP adalah herbisida efisien dan hemat, bekerja secara sistemik untuk mengendalikan gulma sejak awal. Dengan dosis rendah, produk ini selektif, mematikan gulma tanpa merusak tanaman budidaya, dan efektif mengendalikan gulma secara menyeluruh melalui penyerapan akar dan daun.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Metil metsulfuron 20%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('8df8c2e5-5ad8-490f-83b2-57fa0c961f84', '101110506401', 'GOODS', 'Meroke Korn Kali B (KKB) 50kg', 'kg', 762850, 'Meroke Korn Kali B (KKB) 50kg <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Meroke Kom Kali B adalah pupuk majemuk yang mengandung kalium dan magnesium, dirancang untuk meningkatkan kualitas dan hasil tanaman. Cocok untuk berbagai tanaman seperti padi, kentang, cabai, dan kelapa sawit, pupuk ini membantu meningkatkan ukuran, rasa, dan warna buah. Diformulasikan dengan teknologi dari Jerman, produk ini mendukung pertumbuhan tanaman dengan dosis yang disesuaikan berdasarkan jenis tanaman dan kondisi tanah.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk Meroke Korn Kali B memiliki kualitas granular yang memudahkan penyerapan oleh tanaman. Pupuk ini berfungsi untuk mempercepat pertumbuhan dan meningkatkan kualitas hasil produksi tanaman. Selain itu, kandungan klor pada pupuk ini juga meningkatkan fungsi enzim, sintesis protein, dan pembentukan umbi. Pupuk ini juga memperkaya rasa dan warna hasil tanaman, serta membantu meminimalkan biaya aplikasi pupuk, membuatnya menjadi pilihan efektif untuk pertanian.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Kalium oksida 40%</p><p>Magnesium oksida 6%</p><p>Sulfur 4%</p><p>Boron oksida 0,8%</p><p>Bentuk / Warna: Granular / Kecoklatan</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('d8232157-edeb-4ac8-ba5a-0cf53e3c8a06', '101110505701', 'GOODS', 'Kieserite Mahkota 50kg', 'kg', 541500, 'Kieserite (atau nama lainnya Magnesium sulfat) merupakan salah satu sumber yang baik untuk unsur hara magnesium dan belerang. Paling banyak digunakan di pertanian hortikultur, yang mana salah satu keuntungan terbesarnya adalah pupuk ini cocok dengan hampir semua jenis tanaman dan jenis tanah, bagaimanapun kondisi keasaman tanahnya. Kieserite termasuk pupuk yang terurai dan bereaksi dengan cepat dan merupakan pilihan yang tepat ketika unsur hara magnesium dibutuhkan segera <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Kieserite (magnesium sulfat) adalah pupuk yang kaya akan magnesium dan belerang, cocok untuk hampir semua jenis tanaman dan tanah. Cepat larut dan bereaksi efektif, Kieserite ideal untuk memenuhi kebutuhan magnesium tanaman, baik sebelum penanaman atau selama pertumbuhan. Pupuk ini dapat diaplikasikan langsung ke tanah dalam bentuk bubuk atau granular dan dapat diproses menjadi garam Epsom untuk aplikasi irigasi.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Tanah dengan pH rendah, seperti tanah berpasir, membutuhkan tambahan unsur hara ini untuk mendukung pertumbuhan tanaman. Dalam kondisi seperti ini, pemupukan menggunakan Kieserite sangat diperlukan. Sementara itu, tanah di daerah tropis yang berlempung umumnya sudah memiliki kandungan magnesium yang cukup dan jarang mengalami pencucian hara magnesium oleh air.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Magnesium oksida ± 25%</p><p>Sulfur ± 21%</p><p>Bentuk / Warna : Kristal / Putih </p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u> </em></strong>Ya</p>'),
('ecef7b49-b297-4c53-bf53-628861221da7', '101210600101', 'GOODS', 'Pupuk SawitPRO 50kg', 'kg', 1299999, 'C-organik: 15,44%
Rasio C/N: 21,75
Total N: 0,71%
Total P2O5: 3,64%
Total K2O: 17,51%
Kadar air: 19,81%
pH (H2O): 8,97 <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk SawitPRO adalah pupuk organik yang dapat membantu petani kelapa sawit meningkatkan hasil panen dan kualitas buah. Pupuk ini dilengkapi dengan mikroorganisme yang dikembangkan oleh pakar biologi terkemuka di Indonesia. Mikroorganisme dapat dimanfaatkan untuk membantu penguraian hara dan percepatan dari penyerapan hara pada tanaman.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk SawitPRO memberikan berbagai manfaat penting, termasuk meningkatkan ketersediaan unsur hara (Nitrogen, Phosphat, dan Kalium), serta membantu perombakan bahan organik (dekomposisi) dan mineralisasi unsur organik. Pupuk ini juga memicu pertumbuhan tanaman, melindungi akar dari mikroba patogen, meningkatkan efisiensi penyerapan dari pupuk lain (RP, Urea, dll.), dan menghemat biaya pemupukan hingga 50%. Selain itu, Pupuk SawitPRO meningkatkan daya tahan tanaman terhadap serangan penyakit dan menjaga kesuburan tanah untuk pertanian berkelanjutan.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 0,1-1% Nitrogen</p><p>Phosphor pentoksida 3-5%</p><p>Kalium Oksida 17-25%</p><p>Bakteri pengikat nitrogen</p><p>Trichoderma</p><p><br></p><p>Mikroorganisme:</p><p>Rhizobium sp (bakteri pengikat nitrogen pada legume akar)</p><p>Azotobacter sp (bakteri pengikat nitrogen dari udara bebas)</p><p>Streptomyces sp (penghasil antibiotik dan enzim auksin)</p><p>Bacillus sp (melawan patogen dan mendorong pertumbuhan)</p><p>Azospirillum sp (mendorong pertumbuhan)</p><p>Pseudomonas sp (zat pengatur pertumbuhan)</p><p>Trichoderma sp (zat pengontrol hayati terhadap serang jamur khususnya Ganoderma)</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('a48adaed-ab06-4245-8da6-5d560636a1d9', '101110505301', 'GOODS', 'Borate Mahkota - 25kg', 'kg', 1300000, 'Borat/Boron merupakan mikro nutrien yang esensial bagi tanaman. Dibutuhkan dalam jumlah sedikit di aplikasi pemupukan <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Borate Mahkota berisi boron yang merupakan mikronutrien esensial bagi tanaman yang diperlukan dalam jumlah kecil untuk mendukung pertumbuhan optimal. Meskipun biasanya sudah terdapat dalam pupuk NPK, beberapa tanaman dan kondisi tanah tertentu memerlukan tambahan boron.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Peran utama boron bagi tanaman meliputi mendukung pembelahan sel, metabolisme nitrogen, serta pembentukan protein. Selain itu, boron juga berkontribusi penting dalam proses penyerbukan dan produksi benih</p><p><br></p><p><strong><em><u>Kandungan &amp; Spesifikasi</u></em></strong></p><p><br></p><p>Boron trioksida ± 45%</p><p>Tipe Fisik : Kristal warna putih</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('e41e1522-bbe0-4e9b-b638-5470e82e13a5', '101110601501', 'GOODS', 'Mahkota ZA 50kg', 'kg', 497800, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk Mahkota ZA mengandung amonium sulfat, memberikan tambahan nitrogen dan belerang pada tanaman. Bentuknya berupa butiran kristal yang mudah menyerap air dan dapat menurunkan pH tanah, cocok untuk tanah alkali. Meski kandungan nitrogen lebih rendah dari urea, ZA memberikan manfaat tambahan belerang, menjadikannya penting dalam budidaya tebu karena tidak menurunkan kadar gula. Sifat higroskopisnya dan potensi penurunan pH tanah perlu diperhatikan dalam aplikasi.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk belerang Mahkota ZA memberikan manfaat seperti meningkatkan warna hijau daun, kandungan protein dan vitamin pada hasil panen, serta jumlah anak yang dihasilkan pada tanaman padi. Pupuk ini juga mendukung pembentukan zat gula, memperbaiki warna, aroma, dan kelenturan daun tembakau, serta memperbesar umbi bawang merah dan bawang putih, mengurangi penyusutan dan meningkatkan aroma selama penyimpanan.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi </u></em></strong></p><p><br></p><p>N Amonium 21%</p><p>Sulfur 24%</p><p>Kelembaban <3%</p><p>Bentuk / Warna: Kristal / Putih</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('944f4171-813b-4423-ad89-3c73d67f9986', '101110603401', 'GOODS', 'NPK Sawit 13-8-27-4 0.5 B Pak Tani 50kg', 'kg', 817000, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>NPK Sawit 13-8-27-4+0,5B adalah pupuk yang mengandung unsur hara lengkap dan diformulasikan khusus untuk tanaman kelapa sawit pada fase menghasilkan (TM). Kedua formulasi pupuk ini dirancang dengan kandungan unsur hara yang seimbang, menjadikannya sangat cocok untuk kebanyakan lokasi kebun kelapa sawit, karena memenuhi kebutuhan hara tanaman yang rata-rata dibutuhkan oleh kelapa sawit di berbagai kondisi kebun.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk ini mendukung pertumbuhan tanaman, meningkatkan hasil, dan kualitas tanaman dengan memperkuat metabolisme, pembelahan sel, serta pembentukan enzim dan vitamin. Selain itu, juga merangsang pertumbuhan akar dan daun serta meningkatkan imunitas tanaman.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 13%</p><p>Fosfor pentoksida 8%</p><p>Kalium oksida 27%</p><p>Magnesium oksida 4%</p><p>Boron 0,5%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('5110ed03-9e1e-44bd-913c-4f56de2dcf0b', 'MERCH-SAWITPRO-CAP-01', 'GOODS', 'Topi SawitPRO Hijau', 'kg', 35000, 'Topi berlogo SawitPRO warna Hijau Topi berlogo SawitPRO warna Hijau'),
('8fcfd7a8-5980-4e7e-b463-6d30823caac4', '101110602801', 'GOODS', 'Meroke SS - AMMOPHOS 50kg', 'kg', 940500, '<p><strong>Deskripsi</strong></p><p><br></p><p>Pupuk SS (AMMOPHOS) adalah pupuk majemuk dengan formulasi 16% nitrogen, 20% fosfor pentoksida, dan 12% sulfur. Ketiga komponen protein ini dirancang untuk diserap pada fase awal dari pertumbuhan vegetatif akar, daun, dan anakan.</p><p><br></p><p>Bentuk / Warna: Granul / Putih keabu-abuan</p><p><br></p><p><strong>Manfaat</strong></p><p><br></p><p>Pupuk ini kaya akan unsur fosfor dan nitrogen. Unsur fosfor (P) penting untuk mendukung pertumbuhan akar pada tahap awal tanaman, dan ketersediaannya dapat ditingkatkan dengan aplikasi nitrogen (N). Jika P diberikan bersama N, penyerapan P oleh tanaman akan lebih optimal dibandingkan dengan pemberian P tunggal. Selain itu, sulfur (S) juga membantu meningkatkan efisiensi pemupukan N sehingga tanaman dapat menyerap lebih banyak nitrogen.</p><p><br></p><p><strong>Kandungan dan Spesifikasi</strong></p><p><br></p><p>Nitrogen 16%</p><p>Fosfor pentoksida 20%</p><p>Sulfur 12%</p><p><br></p><p><strong>Produk Teruji Lab?</strong> Ya</p>'),
('e8898291-543b-439c-907f-bd80075f02a0', '101110502301', 'GOODS', 'Meroke TSP 50kg', 'kg', 532500, ''),
('fc02857f-92ea-48a1-96b5-95acf43b922e', '202320300103', 'GOODS', 'Bablass 490 SL - 5 Liter', 'kg', 469300, 'BABLASS 490 SL IPA Glifosat 490 g/l. Herbisida sistemik purna tumbuh berbentuk larutan dalam air digunakan untuk Budidaya kelapa sawit (TBM) : gulma berdaun lebar Ageratum conyzoides, Borreria alata, Melastoma affine, Mikania micrantha, gulma berdaun sempit Axonopus compressus <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Bablass 490 SL adalah herbisida sistemik purna tumbuh dalam bentuk larutan air yang digunakan untuk mengendalikan gulma pada budidaya kelapa sawit (TBM), seperti gulma berdaun lebar Ageratum conyzoides, Borreria alata, Melastoma affine, Mikania micrantha, serta gulma berdaun sempit Axonopus compressus.</p><p><br></p><p>Bentuk: Larutan</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Produk ini efektif membunuh rumput secara selektif, menyerap bahan aktifnya ke akar rumput dan mematikannya secara bertahap, tanpa mempengaruhi tanaman lain di sekitarnya.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Isopropil amina (IPA) glifosat 49%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('af58006e-c0d7-44ec-9089-609b74e9ece2', '202320300101', 'GOODS', 'Bablass 490 SL - 1 Liter', 'kg', 102700, 'BABLASS 490 SL IPA Glifosat 490 g/l <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Bablass 490 SL adalah herbisida sistemik purna tumbuh dalam bentuk larutan air yang digunakan untuk mengendalikan gulma pada budidaya kelapa sawit (TBM), seperti gulma berdaun lebar Ageratum conyzoides, Borreria alata, Melastoma affine, Mikania micrantha, serta gulma berdaun sempit Axonopus compressus.</p><p><br></p><p>Bentuk: Larutan</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Produk ini efektif membunuh rumput secara selektif, menyerap bahan aktifnya ke akar rumput dan mematikannya secara bertahap, tanpa mempengaruhi tanaman lain di sekitarnya.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Isopropil amina (IPA) glifosat 49%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('c2b3d62f-6c48-4051-beb1-3ec66d30c1da', '101110500401', 'GOODS', 'RP Cap Daun 50Kg', 'kg', 338200, 'Rock Phosphate (RP)  adalah salah satu sumber fosfat terbaik di dunia yang diolah secara efisien tanpa proses kimia. <p><strong>Deskripsi</strong></p><p><br></p><p>Pupuk RP Cap Daun adalah pupuk yang diproses dari bahan baku galian yang mengandung mineral kalsium fosfat, yang berasal dari batuan yang diolah menjadi bubuk (powder) untuk digunakan langsung dalam pertanian. Pupuk ini dapat diterapkan dalam bentuk bubuk, butiran, atau granular.</p><p><br></p><p><strong>Manfaat</strong></p><p><br></p><p>Memberikan unsur fosfor alami yang dibutuhkan tanaman, mendukung perkembangan akar dan batang, meningkatkan kualitas akar serta batang tanaman, memperbaiki kemampuan tanaman dalam menyerap air dan nutrisi, serta melindungi tanaman dari serangan hama.</p><p><br></p><p><strong>Kandungan dan Spesifikasi</strong></p><p><br></p><p>Fosfor pentoksida 26-28%</p><p><br></p><p><strong>Produk Teruji Lab? </strong>Ya</p>'),
('ff58b8c4-1058-4753-bfc0-c04d091c8485', '101110600701', 'GOODS', 'ZA Cap Daun 50Kg', 'kg', 439375, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>ZA Cap Daun adalah pupuk tunggal yang mengandung 24% belerang dalam bentuk sulfat, yang cepat diserap tanaman untuk mengatasi kekurangan sulfur. Pupuk ini juga mengandung 21% nitrogen yang mudah larut dan cepat diserap oleh tanaman.</p><p><br></p><p>Bentuk: Kristal</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk ZA meningkatkan kualitas dan hasil panen, memperbaiki rasa, warna, serta membuat tanaman lebih tahan terhadap kekeringan, hama, dan penyakit. ZA juga mendukung pembentukan klorofil, meningkatkan kandungan protein dan vitamin, serta memperbaiki warna, aroma, dan kelenturan tembakau, serta memperbesar umbi tanaman bawang.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 21%</p><p>Sulfur 23-24%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('8acff85f-f70a-4308-801f-763b22bb25c7', '101110601001', 'GOODS', 'NPK DGW 13-8-27-4 TE 50kg', 'kg', 798000, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk NPK dari DGW ini diformulasikan khusus untuk tanaman sawit. Dengan kandungan 13-8-27-4+TE, pupuk ini membantu mempercepat pertumbuhan generatif tanaman. Dilengkapi dengan magnesium, boron, dan kalsium, pupuk ini mendukung pertumbuhan tunas yang lebih sehat, daun yang lebih hijau, serta batang dan akar yang kuat. Pupuk ini membantu menghasilkan hasil panen berkualitas dengan warna cerah, cocok untuk berbagai jenis tanaman.</p><p><br></p><p>Bentuk / Warna: Granul / Coklat</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk dengan teknologi Compaction ini memastikan kandungan unsur hara yang terjamin, mengandung berbagai unsur makro dan mikro esensial untuk mendukung pertumbuhan tanaman secara optimal.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 13%</p><p>Fosfor pentoksida 8%</p><p>Kalium oksida 27%</p><p>Magnesium oksida 4%</p><p>Boron 0,65%</p><p>Kalsium oksida</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em></strong><em><u> </u></em>Ya</p>'),
('b53ce31c-3789-42d7-96a0-5fe058cac7a5', '101110502101', 'GOODS', 'RP Mahkota 50kg - Egypt', 'kg', 352688, 'Rock Phosphate (RP) adalah salah satu sumber fosfat terbaik di dunia yang diolah secara efisien tanpa proses kimia. <p><strong>Deskripsi</strong></p><p><br></p><p>Pupuk RP Mesir adalah pupuk yang diproses dari bahan baku galian yang mengandung mineral kalsium fosfat, yang berasal dari batuan yang diolah menjadi bubuk (powder) untuk digunakan langsung dalam pertanian. Pupuk ini dapat diterapkan dalam bentuk bubuk, butiran, atau granular.</p><p><br></p><p><strong>Manfaat</strong></p><p><br></p><p>Memberikan unsur fosfor alami yang dibutuhkan tanaman, mendukung perkembangan akar dan batang, meningkatkan kualitas akar serta batang tanaman, memperbaiki kemampuan tanaman dalam menyerap air dan nutrisi, serta melindungi tanaman dari serangan hama.</p><p><br></p><p><strong>Kandungan dan Spesifikasi</strong></p><p><br></p><p>Fosfor pentoksida 26-28%</p><p><br></p><p><strong>Produk Teruji Lab?</strong> Ya</p>'),
('89f26d03-4933-4924-ae31-5eef6981122f', '101110601701', 'GOODS', 'NPK Mahkota 12-12-17-2 TE 50kg', 'kg', 717250, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk NPK 12-12-17-2+TE mengandung unsur hara mikro yang penting untuk pertumbuhan tanaman. Dirancang untuk pembibitan dan tanaman belum menghasilkan (TBM), pupuk ini juga dapat digunakan pada tanaman menghasilkan (TM) di perkebunan dengan kandungan nitrogen dan fosfor rendah, dengan tambahan hara kalium sesuai rekomendasi. Pupuk ini lebih cocok digunakan di dataran rendah.</p><p><br></p><p>Bentuk / Warna: Granul / Coklat</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk ini mendukung pertumbuhan tanaman, meningkatkan hasil, dan kualitas tanaman dengan memperkuat metabolisme, pembelahan sel, serta pembentukan enzim dan vitamin. Selain itu, juga merangsang pertumbuhan akar dan daun serta meningkatkan imunitas tanaman.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 12%</p><p>Fosfor pentoksida 12%</p><p>Kalium oksida 17%</p><p>Magnesium oksida 2%</p><p>Boron, Tembaga(II) sulfat, Seng sulfat 0,04-0,07%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em> </strong>Ya</p>'),
('ece9fda2-1006-4cf9-a283-74e10b330512', '101110601901', 'GOODS', 'NPK Mahkota 13-8-27-4 0.5 B 50kg', 'kg', 883500, '<p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk NPK Mahkota 13-8-27-4 + 0,5 B mendukung pertumbuhan optimal tanaman perkebunan seperti kelapa sawit, karet, dan kakao. Dengan kandungan 13% Nitrogen, 8% Fosfor, 27% Kalium, 4% Magnesium, dan 0,5% Boron, pupuk ini meningkatkan hasil panen dan kualitas tanaman. Dosis 2–2,5 kg per pohon disarankan untuk kelapa sawit berumur 4–8 tahun.</p><p><br></p><p>Bentuk / Warna: Granul / Coklat</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk ini mendukung pertumbuhan tanaman, meningkatkan hasil, dan kualitas tanaman dengan memperkuat metabolisme, pembelahan sel, serta pembentukan enzim dan vitamin. Selain itu, juga merangsang pertumbuhan akar dan daun serta meningkatkan imunitas tanaman.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 13%</p><p>Fosfor pentoksida 8%</p><p>Kalium oksida 27%</p><p>Magnesium oksida 4%</p><p>Boron 0,5%</p><p>Tembaga(II) sulfat, Seng sulfat 0,02-0,04%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em></strong><em> </em>Ya</p>'),
('5952d124-7dc6-4a6a-baa2-e2e502ecd6fe', 'TUP/PLN/100', 'DIGITAL', 'Token PLN 100.000', '', 109000, 'Topup PLN 100.000 Topup PLN 100.000'),
('c7768e6d-d8d9-469f-960d-879b5401d83c', 'TUP/PLN/200', 'DIGITAL', 'Token PLN 200.000', '', 210000, 'Topup PLN 200.000 Topup PLN 200.000'),
('5501ce77-7a08-4086-8dda-858c92326fc6', '101110603701', 'GOODS', 'Kapur Pertanian Kebomas 50 Kg', 'kg', 241700, 'Tingkatkan pertumbuhan dengan kalsium karbonat 80%. <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Kapur Pertanian Kebomas adalah pupuk berkualitas tinggi dengan komposisi CaCO3 minimal 80%, dirancang untuk meningkatkan pH tanah agar lebih netral dan mendukung ketersediaan unsur hara yang optimal. Produk ini efektif dalam menetralkan senyawa beracun di tanah, memperbaiki struktur tanah, serta merangsang aktivitas mikroorganisme yang mendukung pertumbuhan tanaman. Dengan penggunaan Kapur Pertanian Kebomas, tanaman dapat tumbuh lebih sehat, hasil panen meningkat, dan kualitas tanah menjadi lebih baik.</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Produk ini meningkatkan pH tanah dan air, memperbaiki ketersediaan unsur hara, dan menetralkan senyawa be...(line too long; chars omitted)'),
('6c27fc9c-e7e9-4e9b-9017-292175250df1', '101110603901', 'GOODS', 'NPK Phonska Plus 15-15-15 25kg', 'kg', 441142, 'Tingkatkan pertumbuhan dengan zinc 2000ppm dan sulfur 9%. <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk majemuk NPK yang diperkaya dengan unsur sulfur dan zinc ini dirancang untuk meningkatkan efisiensi dan efektivitas pemupukan. Kandungan sulfur dan zinc tersebut mendukung proses metabolisme tanaman sehingga tidak hanya meningkatkan jumlah hasil panen, tetapi juga kualitasnya, membuat tanaman lebih sehat dan produktif.</p><p><br></p><p>Bentuk / Warna: Granul / Putih</p><p><br></p><p><strong><em><u>Manfaat</u></em></strong></p><p><br></p><p>Pupuk ini mendukung pertumbuhan tanaman, meningkatkan hasil, dan kualitas tanaman dengan memperkuat metabolisme, pembelahan sel, serta pembentukan enzim dan vitamin. Selain itu, juga merangsang pertumbuhan akar dan daun serta meningkatkan imunitas tanaman.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi</u></em></strong></p><p><br></p><p>Nitrogen 15%</p><p>Fosfor pentoksida 15%</p><p>Kalium 15%</p><p>Sulfur 9%</p><p>Zinc 0,2%</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u></em></strong> Ya</p>'),
('4cac8d01-b78e-4017-9113-c627ac1866a5', '101110503801', 'GOODS', 'Urea Nitrea 46% N 50kg', 'kg', 674500, 'Urea Nitrea adalah produk urea retail non subsidi dengan kandungan nitrogen 46% <p><strong>Deskripsi</strong></p><p><br></p><p>Pupuk Urea Nitrea 46% N adalah pupuk kimia dengan kandungan nitrogen (N) tinggi, yaitu 46%, yang berfungsi utama sebagai sumber nitrogen untuk mendukung pertumbuhan vegetatif tanaman. Pupuk ini dapat diaplikasikan dengan cara ditaburkan, disemprotkan, atau menggunakan sistem irigasi.</p><p><br></p><p>Bentuk / Warna: Prill dan granul / Putih</p><p><br></p><p><strong>Manfaat</strong></p><p><br></p><p>Pupuk ini sangat efektif dalam mempercepat pembentukan daun, batang, serta meningkatkan produksi hijauan pada tanaman. Urea Nitrea 46% N cocok digunakan untuk berbagai jenis tanaman, baik untuk pertanian, perkebunan, maupun hortikultura, karena nitrogen adalah unsur hara yang sangat dibutuhkan untuk proses fotosintesis dan pertumbuhan tanaman secara keseluruhan.</p><p><br></p><p><strong>Kandungan dan Spesifikasi</strong></p><p><br></p><p>Nitrogen 46%</p><p><br></p><p><strong>Produk Teruji Lab? </strong>Ya</p>'),
('1af0394e-3aea-42b4-8698-b6832e35f8ce', '101110604001', 'GOODS', 'Petro ZA Plus 50kg', 'kg', 537800, 'Tingkatkan pertumbuhan dengan nitrogen 21% dan sulfur 24 persen. <p><strong>Deskripsi</strong></p><p><br></p><p>Petro ZA Plus efektif untuk merangsang pertumbuhan jumlah anakan, tinggi tanaman, dan jumlah daun. Selain itu, pupuk ini dapat meningkatkan kualitas hasil panen dengan memperbaiki warna, aroma, rasa, dan ukuran buah atau umbi, serta membuat tanaman lebih tahan terhadap hama dan penyakit.</p><p><br></p><p>Bentuk / Warna : Kristal / Hijau</p><p><br></p><p><strong>Manfaat</strong></p><p><br></p><p>Pupuk ini mengandung nitrogen (N), sulfur (S), dan zinc (Zn) yang mendukung pertumbuhan tanaman, meningkatkan jumlah anakan, tinggi tanaman, dan jumlah daun. Pupuk ini juga memperbaiki pembentukan klorofil, meningkatkan warna, aroma, rasa, dan ukuran buah atau umbi, serta meningkatkan kesuburan tanaman, menjadikannya lebih tahan terhadap hama dan penyakit.</p><p><br></p><p><strong>Kandungan dan Spesifikasi</strong></p><p><br></p><p>Nitrogen 21%</p><p>Sulfur 24%</p><p>Zinc 0,1%</p><p>Asam sulfat ≤ 0,1%</p><p><br></p><p><strong>Produk Teruji Lab?</strong> Ya</p>'),
('1033503b-8faa-4d5c-97c2-50bb19fbb897', '101110500501', 'GOODS', 'TSP China Cap Daun 50kg', 'kg', 945000, 'Pupuk TSP China Cap: Formula kaya fosfor, hasil Buah melimpah. <p><strong>Deskripsi</strong></p><p><br></p><p>TSP (Triple Super Phosphate) adalah pupuk yang mengandung fosfor dalam bentuk P2O5 sekitar 44-46%, digunakan untuk memperbaiki kandungan hara pada tanah pertanian. Pupuk ini berbentuk butiran granul berwarna abu-abu dan dapat diterapkan baik sebagai pupuk dasar maupun pupuk susulan.</p><p><br></p><p>Bentuk / Warna: Granul / Abu-abu atau hitam</p><p><br></p><p><strong>Manfaat</strong></p><p><br></p><p>Pupuk Triple Super Phosphate (TSP) dengan kandungan P2O5 44-46% bermanfaat untuk memperkuat sistem perakaran, mendukung pembentukan bunga dan buah, serta meningkatkan ketahanan tanaman terhadap stres. Fosfor yang terkandung juga membantu efisiensi penyerapan unsur hara lain dan memperbaiki struktur tanah. TSP dapat digunakan sebagai pupuk dasar maupun susulan pada berbagai jenis tanaman.</p><p><br></p><p><strong>Kandungan dan Spesifikasi</strong></p><p><br></p><p>Fosfor peroksida 46%</p><p><br></p><p><strong>Produk Teruji Lab? </strong>Ya</p>'),
('9e7cc609-f4ef-4246-89e7-756861e623d8', '101110601101', 'GOODS', 'Dolomite M-100 50kg', 'kg', 136440, 'Pupuk untuk Maksimalkan pH tanah, hasil berlimpah. <p class="ql-align-justify"><strong><em><u>Deskripsi</u></em></strong></p><p class="ql-align-justify"><br></p><p class="ql-align-justify"><span style="background-color: transparent; color: rgb(0, 0, 0);">Dolomite M-100 adalah sumber nutrisi magnesium (Mg) yang ekonomis dan efektif untuk meningkatkan kadar Mg dalam tanah dan daun tanaman kelapa sawit. Selain itu, Dolomite M-100 juga menjadi sumber kalsium (Ca) yang berperan penting dalam merangsang perkembangan sistem perakaran kelapa sawit.</span></p><p class="ql-align-justify"><br></p><p class="ql-align-justify"><strong style="background-color: transparent; color: rgb(0, 0, 0);"><em><u>Manfaat</u></em></strong></p><p class="ql-align-justify"><br></p><p class="ql-align-justify"><span style="background-color: transparent; color: rgb(0, 0, 0);">Produk ini membantu meningkatkan pH tanah, sekaligus menetralkan keracunan aluminium yang sering terjadi pada lahan kelapa sawit yang umumnya bersifat asam. Dengan aplikasi Dolomite M-100, kesuburan tanah akan membaik, efektivitas pemupuk...(line too long; chars omitted)'),
('80957603-6cec-4f63-8dcd-aba6ded5cbdd', '101110501601', 'GOODS', 'MOP/KCL Canada Cap Mahkota 50kg', 'kg', 712500, 'Pupuk MOP/KCL untuk meningkatkan Kualitas dan Kuantitas Buah. <p><strong><em><u>Deskripsi</u></em></strong></p><p><br></p><p>Pupuk MOP/KCL Mahkota mengandung kalium (K2O) minimal 60% dan berguna untuk membantu meningkatkan hasil dan kualitas panen. Pupuk ini juga mengoptimalkan penyerapan unsur hara lainnya dan meningkatkan ketahanan tanaman terhadap hama dan penyakit. Penggunaan KCL sangat penting untuk tanaman tahunan yang membutuhkan kalium tinggi.</p><p><br></p><p><strong><em><u>Manfaat </u></em></strong></p><p>Pupuk kalium oksida (K2O) meningkatkan pertumbuhan dan hasil tanaman dengan menyuplai kalium yang penting untuk daya tahan tanaman terhadap stres, serta mendukung pembentukan buah, bunga, dan umbi. Pupuk ini juga memperbaiki kualitas hasil panen dan efisiensi penggunaan air serta nutrisi, menjadikannya bermanfaat untuk tanaman yang membutuhkan kalium tinggi, seperti padi, jagung, dan tanaman hortikultura.</p><p><br></p><p><strong><em><u>Kandungan dan Spesifikasi </u></em></strong></p><p><br></p><p>Kalium oksida 60%</p><p>Bentuk / Warna: Kristal / Dominan merah</p><p><br></p><p><strong><em><u>Produk Teruji Lab?</u> </em></strong>Ya</p>');

-- Insert into sale order --
INSERT INTO sale_order (id, user_id, total_item_price, created_at_utc0) VALUES
('74be876e-f74b-4633-b403-e07fa9861943', '9c605d36-9c37-4f1e-bac1-c87146fae1f0', 102000000, 1744879059936),
('911a4c25-75d1-4f67-9a8a-40cb365b4cf0', '49ad56f8-8d32-408f-9f88-36cad5310680', 433200, 1744875110464),
('e5819416-6b56-4337-9271-dc2c701ac7bd', '49ad56f8-8d32-408f-9f88-36cad5310680', 1377500, 1744874598061),
('61e68625-9e6a-435d-9bdd-6c2187ca1817', '49ad56f8-8d32-408f-9f88-36cad5310680', 433200, 1744868860328),
('667698fd-6694-4b97-b7f3-e993f1cd7756', '231e825c-16af-4695-bda8-91deb60777e5', 50000, 1744859221323),
('2e93d18b-65de-41be-a43f-3f6e7ce7a5a3', '9e7d6e43-d3b9-4c94-94a2-0029a3fa43cc', 269000, 1744803082027),
('6b843a88-fa74-42b1-a8e8-2c8cbe09cc86', '9c605d36-9c37-4f1e-bac1-c87146fae1f0', 101400000, 1744791925558),
('242572c5-55b4-40e8-9b35-1c25474b6136', 'd428b703-9683-4789-935d-d6a247db6ac7', 380000, 1744789152565),
('86ec48cf-8e0f-4267-be17-fba2c7220d0c', '9c605d36-9c37-4f1e-bac1-c87146fae1f0', 101400000, 1744781279789),
('f0482214-bc2a-430e-8348-4390c2df66a7', 'eaeb96f7-eedc-4613-a2a6-2ac88902ec62', 334500000, 1744777685039),
('1ec9cf2d-5fe6-4a21-b9c5-dfde17c7be47', '9c605d36-9c37-4f1e-bac1-c87146fae1f0', 81700000, 1744689050240),
('630dca51-39ff-4b64-a4ee-6d9007199e8b', '444d489c-eabd-4e37-b21b-d11ebeb28f9b', 267640000, 1744683996778),
('d795c619-731b-495f-9e66-5573e7929507', '49ad56f8-8d32-408f-9f88-36cad5310680', 390000, 1744636452071),
('a1c52691-d8de-4613-84f0-c78abf103cac', '9c605d36-9c37-4f1e-bac1-c87146fae1f0', 101400000, 1744624117945),
('c6e2b534-aa80-47f4-a993-6f9e8801e5f7', 'bc58410c-c5c7-474f-b8ee-8ea16bb3a1b5', 1297500, 1744624086313),
('a73cc2d8-f73e-438c-9d5e-9f14b47fc7c4', '0600fab5-173c-4333-b3c3-c18b37148acf', 72440000, 1744621359373),
('b81ae23b-012b-46fb-ba63-12364918ec31', '972601a1-d233-4387-8b88-fd2611506d1f', 68510000, 1744600528452),
('578e32df-b8f3-4fce-b9c9-2d3e059dcf24', 'e4d68529-9d3c-4db3-bc55-cc3bc3ead00f', 68510000, 1744600184234),
('79753a66-bc18-4aac-9512-fee59f74729f', '1f9c8b9d-1785-4247-9902-f3bf61fc5b70', 1564500, 1744555739587),
('4346187f-5f63-4d5f-8d12-b494143bce30', '87873f2e-bc4f-47da-aca7-5f0b17cd5ef5', 1200000, 1744475586779),
('3a720b4a-b2ca-4ea3-b23c-09e73623241e', '444d489c-eabd-4e37-b21b-d11ebeb28f9b', 68270000, 1744457939054),
('6090bbb6-c528-4223-af54-72394b4166bb', 'e30a4901-7558-4605-9d0d-980adaaa01c2', 2036000, 1744437714676),
('0cfe6a21-74db-45a9-ae87-b39cc733173c', '8c89bfd1-64bf-484a-9860-bab339f48261', 210000, 1744432324868),
('20f151bd-8ad2-4fba-8e33-e900d8036701', 'cddfaf43-dc19-437c-aa34-fac8addcbfb4', 2458500, 1744381986427),
('f5939407-c4f6-4445-b1c2-323614affeb4', 'e4d68529-9d3c-4db3-bc55-cc3bc3ead00f', 68270000, 1744364000829),
('b079c590-e0df-4952-9b5e-6d1a9137fc58', '49ad56f8-8d32-408f-9f88-36cad5310680', 363000, 1744343273310),
('f2339ba3-ceeb-4a35-a19b-27bc13e89698', 'c90e42f6-b841-4267-8c6c-6c0e2fa14911', 5512500, 1744339317963),
('86496962-031e-4f39-a78c-dd907bcd7322', '7a341d40-7166-46d4-b37f-be9a9ecec7f7', 105025000, 1744285662013),
('ef551192-b17a-402b-bd7f-af987a7ac6b3', '49ad56f8-8d32-408f-9f88-36cad5310680', 363000, 1744285204299),
('e0f0d8fe-546b-4746-b35e-063f50786481', '8d2391db-c0d3-4a6a-8ff7-78339f8e68c0', 363000, 1744284780114),
('70ca89e3-70dc-458c-bfa7-65d34bf7ae37', '804b949e-a2ea-4600-b563-5344410f852d', 22000000, 1744277859540),
('9402d7a3-f50c-4943-9474-609eb9701c08', 'a465b71c-48f2-4ed6-9a17-469ebcdc4e66', 130600000, 1744276360644),
('c8ae6bb4-d604-4dae-815a-afbf6a941532', '444d489c-eabd-4e37-b21b-d11ebeb28f9b', 243000000, 1744273107379),
('13b6cc14-5ea1-4675-b0fd-23bc036d582c', '0baaaa63-a05f-492d-8f87-9532257d85f9', 79250000, 1744269444457),
('93f99330-23c3-4928-a7e4-90939bdcf55b', 'ebd171b6-81b8-43f2-afa2-67c5db13845a', 66300000, 1744263828326),
('eec08ac7-8ba3-4ed3-8ac3-c0b409a9e170', 'a2cd71be-a882-4382-a999-e2fecd1ecba4', 2235000, 1744262122807),
('5ae30247-0799-447f-87bd-cb836df433e4', '444d489c-eabd-4e37-b21b-d11ebeb28f9b', 130800000, 1744261575393),
('63df6a83-0a96-4fd0-9942-79049353afd0', '10012ced-8aef-44ed-b6c0-eae920c6e28e', 376000, 1744201737478),
('787bc8b7-e679-4772-be5d-af4afac9adf5', '1e75f22f-b609-4ebc-9536-4a26aef73302', 109000, 1744182202966),
('48620ebf-ee8f-468e-931d-492f9b94690b', '444d489c-eabd-4e37-b21b-d11ebeb28f9b', 80500000, 1744174466182),
('696fc0d9-1456-42a4-9b4b-97c987ac564d', 'be46ecdc-6291-4848-8014-2f910cb3e896', 1412500, 1744127070096),
('c2064f86-6d1e-40ee-9ffe-e29a6f147c88', 'b00e203a-271b-413e-b6ac-a850363339bd', 450000, 1744118473293),
('887c9ab7-c86b-44fd-8623-640028926faf', '9c605d36-9c37-4f1e-bac1-c87146fae1f0', 192750000, 1744100968942),
('fd17275e-5946-42dd-9cb8-205061715f67', 'e4d68529-9d3c-4db3-bc55-cc3bc3ead00f', 68250000, 1744099472465),
('d8255d29-c3ce-4b4e-8b0a-3e0b053ab58a', '444d489c-eabd-4e37-b21b-d11ebeb28f9b', 80500000, 1744097281970),
('79142096-bbba-435a-a8ac-58e4db940d41', '4175d8f7-3242-46cb-9750-25b9804f5177', 13960000, 1744091190468),
('e465e104-5248-4bd6-8650-4388f1a37e0f', 'ebd171b6-81b8-43f2-afa2-67c5db13845a', 22498000, 1744089239565),
('3ddca641-cb59-4a27-8698-cb16ff2932f2', '13f5223e-f04a-4fa8-9ef2-cf36060f0d6d', 90200000, 1744078798583),
('ed5dfc9d-7ef1-427f-92f1-e19ae09e93fa', '9152143a-2ad6-4a45-a0d0-e2a444bbde3d', 15640000, 1744077317898),
('3cf0432a-e5e6-4d23-bd3c-d693b2e27e49', '43999ff4-01db-4bc6-b1fe-4427a918b294', 34850000, 1744067488560),
('0cf2dc54-441b-400b-8785-cbfd9763e9a1', '444d489c-eabd-4e37-b21b-d11ebeb28f9b', 71720000, 1744028143795),
('afbf2c98-e8e6-4ca7-acf3-af3958dfe34f', 'c336fefa-41b7-40cc-95d2-f5a0220f700c', 142500, 1743906806779),
('0beaeb7f-53c8-45de-a937-ad9e12d882c4', 'b93b8e2b-ffa7-4e29-bbf1-c90cce4c0962', 269412, 1743858798601),
('578cf611-f058-4aba-8520-e5d665629acc', 'ec22c8d8-8647-4c0d-8ace-63be2bbe57a0', 154000, 1743854071614),
('ba87bf4a-4099-4101-84fb-ef0248fdf987', '8b621082-7337-4d55-a2ff-e3518797094c', 16537500, 1743843664441),
('f4e69664-e304-4842-b31c-1f1aaf4b0f15', 'd27f2ad2-07c5-4b9f-a40b-26d324547947', 988750, 1743834154255),
('6196b833-aa6f-4508-bfae-bcf61403b9b9', '139fe063-7276-4c10-8926-2a4bb0005e6c', 4545000, 1743735629537),
('acfa3572-d060-4b06-9e27-5a52fafc0314', '59707eb3-194b-42f6-a2be-5c4ca9eeb23a', 972500, 1743691550629),
('a1c94209-33f6-41c7-85ae-63cb368c8954', '438c0b35-30eb-4a57-9577-0f7c13d81eb7', 286350, 1743657022462),
('adfeffc1-dbb4-4a9d-893a-2c9323c31b07', 'ebd171b6-81b8-43f2-afa2-67c5db13845a', 28230000, 1743515778453),
('d890e339-4b42-4957-8faf-1aede573f0ac', '1e62475b-0909-420f-a394-afe02d77ff5e', 316000, 1743132620444),
('2011ece0-28d0-4126-b262-13a28eadbe35', '8c89bfd1-64bf-484a-9860-bab339f48261', 210000, 1743076027507),
('71e506e8-c275-4015-912d-56ba36721b71', 'eae0adf5-7428-4ad8-a4d8-368dd5543992', 70457500, 1743057282268),
('c722fdd0-257a-49b5-8244-c85325091f20', '05dfbe78-f1f3-486d-8bc8-91ef41b3ae78', 1775000, 1743046030332),
('c39f3603-76ef-479c-b866-eed205d15d17', 'eddc7f2d-9b65-477d-8014-65a332d93f37', 5325000, 1742963841248),
('29ae89fb-8d2b-42d7-b985-6e8d9db17bc5', '94c969e0-729a-4b93-9ace-7182276f4ae8', 42300, 1742891997450),
('a1688ca7-4123-4d2a-8ef4-44a0be1580a1', '41bec98e-b466-496b-acf2-e993389ac42b', 19721250, 1742714745447),
('876120bd-3540-4588-b9f5-6beb3acc7e05', 'ecc640f2-61b3-41e4-b2c5-5cd2421da2d8', 20900000, 1742484154298),
('25c230cb-5762-4859-8525-db540f4f9bf3', '5ec10eea-f7ab-4db6-b7b8-142845767460', 15625000, 1742461783284),
('52a06fa1-d0a6-4b8e-b81f-2acb4f971c9a', '74cd1768-c0aa-4a1d-8516-c8323f71b12e', 225000, 1742457388000),
('4d47dd32-1618-4376-a846-66bcf065e173', '344963f8-9a3a-4de3-b3a9-c8716fa37c0e', 65000, 1742438712361),
('5eba2371-a65e-4b2f-8d91-4df09de693c4', '38969042-aa78-4066-b83a-22756b4191ba', 949200, 1742312599373),
('75679458-3b13-4c7d-a8a7-4358a072e4b6', 'c459e2e2-3f03-4ae5-a01f-96958b5b607d', 2104625, 1742302638732),
('0e0144d2-f9a7-49b4-bc35-f6791eceb56b', '468556ca-994d-40aa-9c44-859d8e445a57', 30250000, 1742295827727),
('0733e583-c5db-44a2-8c70-12a731f5240d', '7a341d40-7166-46d4-b37f-be9a9ecec7f7', 68600000, 1742294923364),
('b5b9c2a8-257c-42b4-a102-ca88e4d90297', 'e4d68529-9d3c-4db3-bc55-cc3bc3ead00f', 53360000, 1742272851476),
('b3105663-b5bd-4d93-a095-efa23fce0a98', '0d31385d-79be-436f-9890-69104741bf26', 740000, 1742263399467),
('ae7fdd61-1d4d-44e6-950e-cf1bf4dbd832', '7a341d40-7166-46d4-b37f-be9a9ecec7f7', 136800000, 1742192705332),
('075f1931-927f-4863-bbe4-2c2df643bd4a', '34e01958-7a5d-4016-bb9a-e36d87ed3bf6', 450000, 1741987779826),
('04062e2a-cfd9-4e93-8faa-d8e0d332940a', '05ebeca1-5a73-46ec-88fc-323b29d468cc', 67000000, 1741948143163),
('5afd2d75-6697-426b-a04a-bb28da17e79c', '02b2724f-0227-4c94-a7a0-8cf37f7aee70', 1262515, 1741926761646),
('3b8b547d-8b09-4580-8ba1-5b6636ea72b8', 'bf5af726-2973-481e-8b7a-3d4dd44a9376', 4000000, 1741926568568),
('76a9a3c0-a391-494d-aba6-33110e0646bd', 'e5bd865a-1507-46fd-bcd7-62fe1d8d50ec', 237500, 1741921790177),
('0833fba5-7279-401e-a618-3a0dc911237d', '917278db-9719-4988-a151-237f4fc74b9d', 1505000, 1741870898275),
('fec82ea7-3f70-43eb-97db-e10d9f3073db', 'c84be8f7-1081-46ea-82c5-e4dedda9e39d', 555000, 1741841499266),
('e4fd9369-c7c4-4fbd-8d92-49c7a39caf8d', '6920e798-c041-4c93-88c2-fa188ec4daa0', 3408750, 1741769633779),
('90fb6964-646b-4d85-9cee-a7eaf3f0845d', '8d2391db-c0d3-4a6a-8ff7-78339f8e68c0', 35000, 1741744907551),
('8bfc45e8-a86d-4821-a0ee-1404fbcf8d69', 'd4379720-241d-4186-b07c-e85c05bb143c', 242112, 1741679705843),
('0e0ee1d3-20c5-4660-943f-cbe1501e4921', '2c58c0d7-2214-4747-9ca3-f4f4b75880f9', 64701, 1741578667206),
('72b873a9-54d2-45da-8fb9-92f48d509c52', 'f5a6f92f-7b88-4ccb-896c-0152c50ce4d1', 953860, 1741479226936),
('4ff1a218-220c-48ca-9a43-857cf68edada', 'c51ed79a-e737-40d2-9846-1e842ee3e9a9', 9523200, 1741443085365),
('c7fbc4e1-123f-47c4-b96f-7cd822f6cd3d', '733b3de2-8852-4032-80cb-c785a1b3bb41', 35655000, 1741415210120),
('a1e65a6e-9b83-4683-af78-65cac735332f', '85613812-25e3-495e-b5d8-fab227893c83', 414825, 1741333332621),
('d9b61f55-7569-46a3-8029-010beb05e099', 'bc58410c-c5c7-474f-b8ee-8ea16bb3a1b5', 424000, 1741326971801),
('a0690b8a-1166-46a8-869d-8d62a4f28517', '67050d7d-04e8-4fc3-a2eb-ac1b533dd222', 40500000, 1741255055383),
('d20a9066-aed8-4082-98e6-7abc62b7bf78', '9419bea1-d06e-4c66-ad5f-f395aeb3af29', 3934864, 1741222331703),
('687f6dff-de2f-44d4-a159-68661c5a56b5', '695e066a-270e-461d-9f04-7893b57603eb', 6056160, 1741176262589),
('95505675-172d-4cee-8240-0b2e5ef6d5b1', 'c51ed79a-e737-40d2-9846-1e842ee3e9a9', 9523200, 1741168499832),
('3c8e9748-d5f2-46e9-bdbf-82f1c443226c', 'd81b9980-35d6-4701-8692-03b5b34e0243', 305250, 1741152076724),
('c09f7ada-801a-4bd9-a04f-54f9c56bab2b', '8c5c639f-2c15-4b35-8ee3-f1302b3c82a6', 19361824, 1741150946062);

-- Insert into sale order item --
INSERT INTO sale_order_item (id, sale_order_id, product_id, price, quantity) VALUES
('d4dc9c06-177e-494c-ba72-7e2954ce8ced', '3ddca641-cb59-4a27-8698-cb16ff2932f2', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 326000, 200),
('7eefa7db-26bf-4a8b-b207-f44a52ed0aba', '3ddca641-cb59-4a27-8698-cb16ff2932f2', 'b53ce31c-3789-42d7-96a0-5fe058cac7a5', 125000, 200),
('e9b32dc3-4e0f-4a69-bb3d-c7f11277f97f', '787bc8b7-e679-4772-be5d-af4afac9adf5', '5952d124-7dc6-4a6a-baa2-e2e502ecd6fe', 109000, 1),
('86a41dec-9936-4c8f-9150-e8b367a4959f', '4d47dd32-1618-4376-a846-66bcf065e173', '0bd2430a-6613-442a-9d5a-11d64cb095ae', 65000, 1),
('61cf5f3f-2a24-4080-bc4f-50af3506479d', 'e5819416-6b56-4337-9271-dc2c701ac7bd', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 688750, 2),
('1f3f0ae1-f790-4ca1-9775-d28a1917770f', '0e0144d2-f9a7-49b4-bc35-f6791eceb56b', '4698d965-a133-4701-838b-f60e38c66b39', 302500, 100),
('4ebafa85-bc91-4685-9775-3cc06be3f4b6', 'a1688ca7-4123-4d2a-8ef4-44a0be1580a1', '6c27fc9c-e7e9-4e9b-9017-292175250df1', 219125, 90),
('60978d0a-d163-4f86-b62d-9879e4310e55', '578cf611-f058-4aba-8520-e5d665629acc', 'b53ce31c-3789-42d7-96a0-5fe058cac7a5', 154000, 1),
('5648a5d8-912a-4dc3-a660-a6b914d72cbb', 'f4e69664-e304-4842-b31c-1f1aaf4b0f15', 'b53ce31c-3789-42d7-96a0-5fe058cac7a5', 141250, 7),
('23613597-9595-435c-9a30-9cddd993c7ca', '0cfe6a21-74db-45a9-ae87-b39cc733173c', 'c7768e6d-d8d9-469f-960d-879b5401d83c', 210000, 1),
('67a8b8ce-99c6-431e-b220-beeed6431818', '667698fd-6694-4b97-b7f3-e993f1cd7756', 'c1d06ac3-5bea-4b4d-8648-ae3fa531f059', 50000, 1),
('bf780266-6e93-4b91-b284-69b2aef34b4c', '72b873a9-54d2-45da-8fb9-92f48d509c52', 'ecef7b49-b297-4c53-bf53-628861221da7', 190772, 5),
('a49cd0c9-2017-411a-ad73-93086e1700c4', 'fd17275e-5946-42dd-9cb8-205061715f67', '4cac8d01-b78e-4017-9113-c627ac1866a5', 341250, 200),
('94d0ddd6-bbdb-422a-b7f5-078a9c3b2c4f', '0e0ee1d3-20c5-4660-943f-cbe1501e4921', 'af58006e-c0d7-44ec-9089-609b74e9ece2', 64701, 1),
('d518112f-0310-4f5c-82fc-c568da34a0d8', '3c8e9748-d5f2-46e9-bdbf-82f1c443226c', '4698d965-a133-4701-838b-f60e38c66b39', 305250, 1),
('340d4837-86c0-4779-a9dc-5757cef13890', '86496962-031e-4f39-a78c-dd907bcd7322', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 345000, 200),
('06bcc5f9-1f75-4569-b18a-fa26102e8223', '86496962-031e-4f39-a78c-dd907bcd7322', '4cac8d01-b78e-4017-9113-c627ac1866a5', 360250, 100),
('3799d194-1e1b-4839-bd38-244b23d7e71d', '52a06fa1-d0a6-4b8e-b81f-2acb4f971c9a', '6c27fc9c-e7e9-4e9b-9017-292175250df1', 225000, 1),
('4b98e69d-83ab-4739-8091-88a5994cbf7c', 'f0482214-bc2a-430e-8348-4390c2df66a7', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 334500, 1000),
('97259026-8094-49ab-8edb-6b136aa2a772', '0cf2dc54-441b-400b-8785-cbfd9763e9a1', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 326000, 220),
('05cbbbb3-c529-42af-9c9d-c216e62f40cc', 'e465e104-5248-4bd6-8650-4388f1a37e0f', 'a48adaed-ab06-4245-8da6-5d560636a1d9', 410000, 3),
('a3a8b5fe-5d22-49f6-9553-b087239edda6', 'e465e104-5248-4bd6-8650-4388f1a37e0f', 'e8898291-543b-439c-907f-bd80075f02a0', 531700, 40),
('9673a5c8-e6d7-4886-b4c7-7b6665979eac', '71e506e8-c275-4015-912d-56ba36721b71', '89f26d03-4933-4924-ae31-5eef6981122f', 358750, 90),
('5ea216e7-3388-4e06-b15e-a06e2a2c5817', '71e506e8-c275-4015-912d-56ba36721b71', '4cac8d01-b78e-4017-9113-c627ac1866a5', 347000, 110),
('e1350bca-da3f-4531-aae7-1f5571c5117c', '70ca89e3-70dc-458c-bfa7-65d34bf7ae37', 'ff58b8c4-1058-4753-bfc0-c04d091c8485', 220000, 100),
('b59e8e7b-5309-46a7-9931-c2156cfe019b', '5ae30247-0799-447f-87bd-cb836df433e4', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 327000, 400),
('c92d044e-8a04-43fb-91c9-9af1760ca8b9', '76a9a3c0-a391-494d-aba6-33110e0646bd', 'fc02857f-92ea-48a1-96b5-95acf43b922e', 237500, 1),
('b9d6ec6f-094b-494a-aa64-238599f2b18c', 'c39f3603-76ef-479c-b866-eed205d15d17', '2b8fe2f0-5d07-459c-8781-22305a61980a', 35500, 150),
('dc6c4b16-45c6-4051-a3ef-eb8f7fc9b6c6', 'ed5dfc9d-7ef1-427f-92f1-e19ae09e93fa', '8fcfd7a8-5980-4e7e-b463-6d30823caac4', 488750, 32),
('07e84a6c-ae3f-4559-bc14-522dc885d6d3', 'a1c52691-d8de-4613-84f0-c78abf103cac', 'beb17fe4-5d92-4738-adaa-2d62ffb83516', 338000, 300),
('5ce2f974-402d-4b4a-a572-812e661c7cdc', 'ef551192-b17a-402b-bd7f-af987a7ac6b3', 'ecef7b49-b297-4c53-bf53-628861221da7', 363000, 1),
('a80aa175-bf00-4816-8ac1-7ac8954d68f7', 'a0690b8a-1166-46a8-869d-8d62a4f28517', '487f2886-5150-4269-94e2-63fbc7314971', 45000, 900),
('3cdded98-17ef-479d-bb73-2799dbd9c307', '0833fba5-7279-401e-a618-3a0dc911237d', 'e41e1522-bbe0-4e9b-b638-5470e82e13a5', 215000, 7),
('2247016d-0647-4faf-9cd8-6f43324d21ec', '63df6a83-0a96-4fd0-9942-79049353afd0', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 376000, 1),
('7281ae70-a5bf-4008-a17d-7e6723c7e980', 'd20a9066-aed8-4082-98e6-7abc62b7bf78', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 359425, 3),
('3f98251a-2968-4d51-999b-aa0bf0fe37a4', 'd20a9066-aed8-4082-98e6-7abc62b7bf78', 'b53ce31c-3789-42d7-96a0-5fe058cac7a5', 134250, 2),
('240ed567-7424-4996-b0d7-ed1a529b0188', 'd20a9066-aed8-4082-98e6-7abc62b7bf78', '369cfbc5-f536-41f5-8a80-267d55dec802', 229417, 2),
('990f313c-c9f4-4c66-aff8-e60ad1f442d0', 'd20a9066-aed8-4082-98e6-7abc62b7bf78', 'c2b3d62f-6c48-4051-beb1-3ec66d30c1da', 136750, 2),
('016980c2-5d06-42ae-99bc-fd609efb42fe', 'd20a9066-aed8-4082-98e6-7abc62b7bf78', '1af0394e-3aea-42b4-8698-b6832e35f8ce', 239250, 2),
('688c7a61-01bb-4dd0-9966-0992bd97c6f6', 'd20a9066-aed8-4082-98e6-7abc62b7bf78', '1033503b-8faa-4d5c-97c2-50bb19fbb897', 507250, 2),
('d9fb91ef-fe89-496f-90db-94e7d1405c33', 'd20a9066-aed8-4082-98e6-7abc62b7bf78', 'a48adaed-ab06-4245-8da6-5d560636a1d9', 362755, 1),
('95826d7a-3dac-42c9-a9c9-f1cb4f9f7e27', 'fec82ea7-3f70-43eb-97db-e10d9f3073db', '4698d965-a133-4701-838b-f60e38c66b39', 555000, 1),
('6c0a4806-7d61-4633-855b-559274b38a53', '578e32df-b8f3-4fce-b9c9-2d3e059dcf24', '4cac8d01-b78e-4017-9113-c627ac1866a5', 342550, 200),
('4c791ad8-eca6-435f-b7c0-e0976848d4dd', '6b843a88-fa74-42b1-a8e8-2c8cbe09cc86', 'beb17fe4-5d92-4738-adaa-2d62ffb83516', 338000, 300),
('ae18c294-ba72-4bef-bcca-1609fb7e41ef', '3b8b547d-8b09-4580-8ba1-5b6636ea72b8', '8acff85f-f70a-4308-801f-763b22bb25c7', 400000, 10),
('a4f6c073-f425-45a4-9b73-2a8562432953', 'ae7fdd61-1d4d-44e6-950e-cf1bf4dbd832', 'ece9fda2-1006-4cf9-a283-74e10b330512', 425000, 200),
('bb06b4d5-60aa-4c9c-821b-03cafd7d5c8d', 'ae7fdd61-1d4d-44e6-950e-cf1bf4dbd832', '1033503b-8faa-4d5c-97c2-50bb19fbb897', 518000, 100),
('b37eb9bc-42f3-4a9a-a223-ada4c70f75be', 'c722fdd0-257a-49b5-8244-c85325091f20', '5501ce77-7a08-4086-8dda-858c92326fc6', 71000, 25),
('26a34fc9-a9c7-433c-88e9-eefc25facc6d', '61e68625-9e6a-435d-9bdd-6c2187ca1817', '6c27fc9c-e7e9-4e9b-9017-292175250df1', 433200, 1),
('7176d030-76cc-47cd-958b-69dd04562782', '5eba2371-a65e-4b2f-8d91-4df09de693c4', 'c2b3d62f-6c48-4051-beb1-3ec66d30c1da', 158200, 6),
('c2041d0e-7704-4e60-a167-5b55bd6abcf5', '3cf0432a-e5e6-4d23-bd3c-d693b2e27e49', '4cac8d01-b78e-4017-9113-c627ac1866a5', 348500, 100),
('ffb9c011-6f36-4fa2-8280-b3e23c1e3b2c', '95505675-172d-4cee-8240-0b2e5ef6d5b1', '9e7cc609-f4ef-4246-89e7-756861e623d8', 47616, 200),
('b820dd8f-1b88-43af-abaf-0d10977f676e', '2011ece0-28d0-4126-b262-13a28eadbe35', 'c7768e6d-d8d9-469f-960d-879b5401d83c', 210000, 1),
('cb8c3650-edab-4c44-afe0-117e12b0de93', 'a1c94209-33f6-41c7-85ae-63cb368c8954', 'fc02857f-92ea-48a1-96b5-95acf43b922e', 238350, 1),
('18906374-1b30-4b21-baaa-ae32e0595283', 'a1c94209-33f6-41c7-85ae-63cb368c8954', '6eccf249-a997-4091-8d64-29f1e9accd85', 48000, 1),
('28690cb4-dcf6-43a9-9cfd-5ea69455a1ed', '20f151bd-8ad2-4fba-8e33-e900d8036701', '8152e395-0f7a-4dda-8df9-6655a726c4e1', 223500, 11),
('340fe0d5-920a-4be1-8d55-5ae77e74bea9', 'afbf2c98-e8e6-4ca7-acf3-af3958dfe34f', 'b53ce31c-3789-42d7-96a0-5fe058cac7a5', 142500, 1),
('2149c154-13f2-4ae4-ae20-007067e6c325', 'f5939407-c4f6-4445-b1c2-323614affeb4', '4cac8d01-b78e-4017-9113-c627ac1866a5', 341350, 200),
('48b8d849-ebe3-4553-8c48-3c8337afc942', '887c9ab7-c86b-44fd-8623-640028926faf', '4cac8d01-b78e-4017-9113-c627ac1866a5', 321250, 600),
('75b68177-105a-4b5b-b2e3-730c9d62503d', 'c7fbc4e1-123f-47c4-b96f-7cd822f6cd3d', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 356550, 100),
('b359bef3-c01d-4299-aeb4-9c12f849db35', '74be876e-f74b-4633-b403-e07fa9861943', 'beb17fe4-5d92-4738-adaa-2d62ffb83516', 340000, 300),
('3f022532-e12d-4a1b-802d-4e8e3ce8f67a', 'c6e2b534-aa80-47f4-a993-6f9e8801e5f7', '944f4171-813b-4423-ad89-3c73d67f9986', 432500, 3),
('1292c19e-4c7f-4181-be1c-a2d2c71f293c', '29ae89fb-8d2b-42d7-b985-6e8d9db17bc5', '2485b082-5258-44c1-b6aa-983387d540a7', 42300, 1),
('24e50f16-f8eb-4251-8dae-62e8de0b9115', '79142096-bbba-435a-a8ac-58e4db940d41', '4cac8d01-b78e-4017-9113-c627ac1866a5', 349000, 40),
('acf8379a-4939-4b2e-8c11-c367e9f3f916', '90fb6964-646b-4d85-9cee-a7eaf3f0845d', '5110ed03-9e1e-44bd-913c-4f56de2dcf0b', 35000, 1),
('b0d7cb11-722e-41aa-a72f-57371c8c3575', '48620ebf-ee8f-468e-931d-492f9b94690b', 'ece9fda2-1006-4cf9-a283-74e10b330512', 402500, 200),
('f7cfd4be-40f7-4e78-ae02-47adf059ec89', '6090bbb6-c528-4223-af54-72394b4166bb', 'c5e57af4-0df9-4e2b-87e4-9024b8e6cf53', 89000, 10),
('457d3ae5-f9ad-414b-ba7c-b69c98262cb8', '6090bbb6-c528-4223-af54-72394b4166bb', 'b67588d2-e8fe-4ee4-9931-e9d18241d04c', 191000, 6),
('dfd7f284-2b59-43e9-b5a5-340269e3a278', 'f2339ba3-ceeb-4a35-a19b-27bc13e89698', '8152e395-0f7a-4dda-8df9-6655a726c4e1', 220500, 25),
('440e35d0-183f-4676-931e-24c157d9a058', '25c230cb-5762-4859-8525-db540f4f9bf3', '4698d965-a133-4701-838b-f60e38c66b39', 312500, 50),
('1487461c-f4b2-4507-9c10-8d9f6eaa0c80', '687f6dff-de2f-44d4-a159-68661c5a56b5', '4698d965-a133-4701-838b-f60e38c66b39', 302808, 20),
('78995a56-1552-43c0-8d77-da0523f5821e', 'a1e65a6e-9b83-4683-af78-65cac735332f', '8df8c2e5-5ad8-490f-83b2-57fa0c961f84', 414825, 1),
('038a690b-4c3f-4083-8f36-94346f314e4a', 'ba87bf4a-4099-4101-84fb-ef0248fdf987', '8152e395-0f7a-4dda-8df9-6655a726c4e1', 220500, 75),
('b0110dd5-1a8a-485d-b519-4555cd1cf052', 'd8255d29-c3ce-4b4e-8b0a-3e0b053ab58a', 'ece9fda2-1006-4cf9-a283-74e10b330512', 402500, 200),
('39678113-4979-451c-ad19-95b0ffa7c4c6', 'e0f0d8fe-546b-4746-b35e-063f50786481', 'ecef7b49-b297-4c53-bf53-628861221da7', 363000, 1),
('4ef3dae3-a6c7-4015-90c7-7bcd17772695', '911a4c25-75d1-4f67-9a8a-40cb365b4cf0', '6c27fc9c-e7e9-4e9b-9017-292175250df1', 433200, 1),
('efa2b948-d22c-4efd-b4c9-edd1970fe1cb', '13b6cc14-5ea1-4675-b0fd-23bc036d582c', '8acff85f-f70a-4308-801f-763b22bb25c7', 396250, 200),
('43a801f8-1e93-4f60-b8cc-d8f398fec514', '75679458-3b13-4c7d-a8a7-4358a072e4b6', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 420925, 5),
('8aa1ce91-5fde-4157-b0fd-2fa76ead5e0e', '6196b833-aa6f-4508-bfae-bcf61403b9b9', 'c2b3d62f-6c48-4051-beb1-3ec66d30c1da', 126250, 36),
('f3ef59fc-c7a5-4902-8ea6-14da5e858b18', 'd9b61f55-7569-46a3-8029-010beb05e099', '8acff85f-f70a-4308-801f-763b22bb25c7', 424000, 1),
('ed1b77aa-305b-461e-a25a-c6543dbfea31', 'b81ae23b-012b-46fb-ba63-12364918ec31', '4cac8d01-b78e-4017-9113-c627ac1866a5', 342550, 200),
('62bbe60c-02c0-4d83-a65a-c94955682247', 'adfeffc1-dbb4-4a9d-893a-2c9323c31b07', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 358750, 40),
('a1d93776-17d7-4ec3-836b-4c2d752aa5d5', 'adfeffc1-dbb4-4a9d-893a-2c9323c31b07', '4cac8d01-b78e-4017-9113-c627ac1866a5', 347000, 40),
('9a19670b-56a1-4e4e-95d9-572535e0de4e', '696fc0d9-1456-42a4-9b4b-97c987ac564d', 'b53ce31c-3789-42d7-96a0-5fe058cac7a5', 141250, 10),
('b44ee7bc-467e-4a31-af1f-ea588813849f', '5afd2d75-6697-426b-a04a-bb28da17e79c', 'fc02857f-92ea-48a1-96b5-95acf43b922e', 252503, 5),
('1903eab7-b4c2-4376-b33c-7b28b0d5ec16', 'b079c590-e0df-4952-9b5e-6d1a9137fc58', 'ecef7b49-b297-4c53-bf53-628861221da7', 363000, 1),
('de185ea0-e80d-416c-8904-2ac29a8ed83c', 'e4fd9369-c7c4-4fbd-8d92-49c7a39caf8d', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 378750, 9),
('33c92cf9-519a-4d97-b929-e3492261c55e', '2e93d18b-65de-41be-a43f-3f6e7ce7a5a3', '1af0394e-3aea-42b4-8698-b6832e35f8ce', 269000, 1),
('27281874-4cbd-4841-a598-1476057c32a6', '075f1931-927f-4863-bbe4-2c2df643bd4a', 'ecef7b49-b297-4c53-bf53-628861221da7', 450000, 1),
('c829e71b-2a29-401b-a5c9-ebe4bb6a8dc3', '630dca51-39ff-4b64-a4ee-6d9007199e8b', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 334550, 800),
('e4437a71-0ad4-4204-8ab3-0d41b83f98ea', '1ec9cf2d-5fe6-4a21-b9c5-dfde17c7be47', 'ece9fda2-1006-4cf9-a283-74e10b330512', 408500, 200),
('514a487e-2dbb-472f-8a63-5c92ec484975', '876120bd-3540-4588-b9f5-6beb3acc7e05', 'd3999f4e-890a-473f-bb92-2fd2178da3fb', 380000, 55),
('f089d785-716d-4024-aa48-68ff18ab8e9d', 'd890e339-4b42-4957-8faf-1aede573f0ac', 'b53ce31c-3789-42d7-96a0-5fe058cac7a5', 158000, 2),
('5e7f36c2-6bab-40e2-a5e8-3c93c08d98cc', 'c2064f86-6d1e-40ee-9ffe-e29a6f147c88', '8152e395-0f7a-4dda-8df9-6655a726c4e1', 225000, 2),
('1e8cf8b7-d68b-4d59-82ee-bb9d8e074214', '242572c5-55b4-40e8-9b35-1c25474b6136', 'd3999f4e-890a-473f-bb92-2fd2178da3fb', 380000, 1),
('dd97661a-27f9-4b8e-b30a-ecd28e3403b8', '04062e2a-cfd9-4e93-8faa-d8e0d332940a', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 335000, 200),
('b77347a1-d161-4345-bb3b-3a25a83ecddb', '9402d7a3-f50c-4943-9474-609eb9701c08', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 326500, 400),
('6f5b5ff9-f5dd-40d3-997f-57e7b6951d99', '3a720b4a-b2ca-4ea3-b23c-09e73623241e', '4cac8d01-b78e-4017-9113-c627ac1866a5', 341350, 200),
('709d7102-53c8-471b-a0a9-6e653ab53431', '86ec48cf-8e0f-4267-be17-fba2c7220d0c', 'beb17fe4-5d92-4738-adaa-2d62ffb83516', 338000, 300),
('0caffd9a-d40f-4a8a-9dce-9f90ddf91cd2', 'acfa3572-d060-4b06-9e27-5a52fafc0314', 'a48adaed-ab06-4245-8da6-5d560636a1d9', 486250, 2),
('6b4a6eaa-6b2e-4885-bd6a-b7a1f1d15a61', 'c8ae6bb4-d604-4dae-815a-afbf6a941532', 'ece9fda2-1006-4cf9-a283-74e10b330512', 405000, 600),
('a09d0cb7-a9a8-4c73-99ba-a776eb9792f2', 'd795c619-731b-495f-9e66-5573e7929507', 'a48adaed-ab06-4245-8da6-5d560636a1d9', 390000, 1),
('2b49896c-e8f5-44d1-9011-7ac912c1f454', '93f99330-23c3-4928-a7e4-90939bdcf55b', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 331500, 200),
('69768dc2-5272-4c05-874b-b7bb2903852c', '8bfc45e8-a86d-4821-a0ee-1404fbcf8d69', '76fddc47-aea9-4942-9dbd-19d90f31cdd4', 242112, 1),
('187f51fb-68ae-44ba-ba89-d7280d833878', 'eec08ac7-8ba3-4ed3-8ac3-c0b409a9e170', '8152e395-0f7a-4dda-8df9-6655a726c4e1', 223500, 10),
('b9bb609a-c421-4bbb-a8a8-04e3b83ed752', 'c09f7ada-801a-4bd9-a04f-54f9c56bab2b', '4698d965-a133-4701-838b-f60e38c66b39', 302808, 50),
('b4629ea5-41ca-430d-b6c6-bc68a75e104a', 'c09f7ada-801a-4bd9-a04f-54f9c56bab2b', 'd8232157-edeb-4ac8-ba5a-0cf53e3c8a06', 263839, 16),
('4794c11e-6b49-4474-8fe7-15cbb071ee87', '0733e583-c5db-44a2-8c70-12a731f5240d', '80957603-6cec-4f63-8dcd-aba6ded5cbdd', 343000, 200),
('62dbbd91-0a49-482e-9367-50088bb3dcb8', 'a73cc2d8-f73e-438c-9d5e-9f14b47fc7c4', '4cac8d01-b78e-4017-9113-c627ac1866a5', 362200, 200),
('d3cf1b96-0028-4a6c-8c4a-0cd47fc1e0d5', '4346187f-5f63-4d5f-8d12-b494143bce30', '8acff85f-f70a-4308-801f-763b22bb25c7', 400000, 3),
('109a599b-2339-4e46-9600-09ef5431ea86', 'b3105663-b5bd-4d93-a095-efa23fce0a98', 'ece9fda2-1006-4cf9-a283-74e10b330512', 450000, 1),
('708a7fd8-ce01-46aa-b2a9-f985a5213bc0', 'b3105663-b5bd-4d93-a095-efa23fce0a98', 'c2b3d62f-6c48-4051-beb1-3ec66d30c1da', 145000, 2),
('11e21300-3835-4785-b739-6e0cfce54e02', 'b5b9c2a8-257c-42b4-a102-ca88e4d90297', '4cac8d01-b78e-4017-9113-c627ac1866a5', 333500, 160),
('d24bd69e-a035-4b3a-ab8e-1b2d60e92489', '79753a66-bc18-4aac-9512-fee59f74729f', '8152e395-0f7a-4dda-8df9-6655a726c4e1', 223500, 7),
('defa0c3d-8d21-4a3e-8676-3638e99cedb7', '4ff1a218-220c-48ca-9a43-857cf68edada', '9e7cc609-f4ef-4246-89e7-756861e623d8', 47616, 200),
('b430eaaf-921b-4b68-8a34-d1b4f72dcc85', '0beaeb7f-53c8-45de-a937-ad9e12d882c4', '701928af-24e9-4a13-aaad-63ede44be9c8', 269412, 1);

--------------------------------
--- Your SQL queries here    ---
--- You may add more schemas or data if needed ---
--- Should you create more schemas/tables please add prefix to the table name `np25<team_number>_<table_name>` ---
--- Example: np2501_table_name ---
--------------------------------
