# PROYEK AKHIR PERANCANGAN SISTEM DIGITAL
## INFO
No. Kelompok : B2

Judul Proyek : VENDING MACHINE

Anggota Kelompok :
1. (1806200381) Mohammad Salman Alfarisi
2. (1806148675) Fatur Rahman Stoffel
3. (1806200034) Syahmi Mutahajjid Priyagi
4. (1806148630) Aditya Ghalib Hendryan

## PENJELASAN PROYEK
Proyek ini berupa sebuah program dalam bentuk VHDL code. Program dibuat bedasarkan materi pembelajaran yang telah didapatkan dalam mata kuliah Perancangan Sistem Digital mengenai Finite State Machine.

Cara kerja dari program tersebut mengikuti sebuah vending machine pada umumnya, yaitu terdapat input berupa sejumlah uang, lalu terdapat proses pemilihan produk, serta output berupa produk yang dipilih.

Terdapat tiga variabel jenis uang yang diprogram dalam code biner, yaitu:
1. Rp5.000,00 dengan kode 01
2. Rp10.000,00 dengan kode 10
3. Rp20.000,00 dengan kode 11

Terdapat 11 variabel jenis produk dengan diantaranya 5 produk makanan dan 6 produk minuman dengan kelas harga yang berbeda-beda. Variabel tersebut juga diprogram dalam kode biner (lebih lengkapnya lihat pada file pptx).

Ketika input dimasukkan berupa nominal uang, maka jumlah maksimal uang yang bisa terbaca oleh vending machine yaitu sebesar Rp20.000,00. Ketika harga produk yang dipilih dibawah jumlah uang maksimum yang di input, maka terdapat varibel 'change' sebagai kembalian. Program akan selesai apabila jumlah kembalian bernilai Rp0.000,00 dan akan meminta input uang dari awal kembali.

Digunakan dua file vhdl dalam proses pembuatannya. Pada file vending_machine.vhd merupakan program utama dalam menjalankan simulasi vending machine tersebut, sedangkan pada file ram32x4_dual.vhd digunakan sebagai tempat untuk menyimpan variabel jenis-jenis produk makanan dan minuman yang kemudian akan dipanggil kedalam program utama.

Untuk menjalankan simulasi program VHDL, digunakan software Intel Quartus Lite dan software ModelSIM (sudah include dalam software Intel Quartus Lite). Kedua program akan dicompile lalu untuk menjalankan simulasi cukup file vending_machine.vhd saja yang disimulasi. Cara mensimulasikan file vhd pada software Intel Quartus Lite bisa dicari diberbagai referensi yang ada di internet.

Tahapan Simulasi:
1. Mengatur variabel 'CLK' dan 'nCLK' sebagai sinyal clock.
2. Mengubah code biner pada variabel 'money' sesuai dengan jumlah uang yang akan dimasukkan.
3. Mengubah code biner pada variabel 'sel' untuk memilih jenis produk.
4. Variabel 'money' bisa ditambah ketika sedang dalam proses pemilihan produk apabila memang ingin menambah jumlah uang untuk membeli produk yang lainnya.
5. Selama variabel 'change' belum mencapai Rp0.000,00, maka program masih berjalan dengan meminta input varibel 'sel'.
6. Proses program akan berhenti ketika variabel 'change' bernilai Rp0.000,00 dengan ditandai variabel 'state' menunjukkan fin (yang berarti finish) dan 'next_state' menunjukkan start (dimana program akan mengulang kembali proses dari awal dengan meminta input variabel 'money')

Untuk lebih jelasnya bisa lihat video penjelasan yang sudah kelompok kami buat di link berikut ini. Klik [disini](https://youtu.be/b2_vGVoKoEY).
