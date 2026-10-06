# PixeL UI 1.2 — riset dan perbaikan layout

Pemilik: Jeaneism · https://0x4.me

## Temuan dari dua screenshot

1. Watermark FPS/PING/TIME adalah panel terpisah di tengah atas layar. Panel ini menimpa judul dan subtitle jendela, sehingga identitas tampil ganda.
2. Pada jendela pendek, header dikurangi menjadi 42 px tetapi deskripsi masih terlihat sampai posisi 52 px. PageHost dimulai sebelum deskripsi selesai: penyebab konkret teks terpotong.
3. `State.Touch` selalu memaksa konten satu kolom. Layar landscape lebar tetap menumpuk kartu dashboard yang tinggi, sementara ruang horizontal kosong.
4. Tab besar dengan bayangan 6 px, outline tebal, warna kuning penuh dan banyak bingkai membuat navigasi lebih dominan daripada isi.
5. Kartu angka sederhana memakai tinggi 90 px; kartu multiline 130 px. Ikon panel 32 px dan tombol mengambang 56 px menambah kepadatan visual.

## Riset yang dipakai

- [W3C — Understanding Reflow](https://www.w3.org/WAI/WCAG22/Understanding/reflow.html): konten perlu menyesuaikan ruang layar agar dapat dibaca tanpa kehilangan informasi atau fungsi. Diterapkan sebagai pemeriksaan header, viewport dan perubahan jumlah kolom berdasarkan lebar, bukan jenis input.
- [Roblox — ScrollingFrame](https://create.roblox.com/docs/reference/engine/classes/ScrollingFrame): `ScrollingDirection`, `CanvasSize` dan `CanvasPosition` mengatur arah, area dan posisi scroll. Diterapkan untuk satu baris tab horizontal dengan swipe, panah, scrollbar, batas scroll dan tab aktif yang masuk ke viewport.
- [W3C — Target Size (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html): target interaksi perlu ukuran dan jarak yang cukup. Tab touch tetap memiliki target besar meskipun ikon dan outline dirampingkan. Satuan CSS pada sumber dipakai sebagai referensi prinsip, bukan klaim kepatuhan untuk Roblox.
- [Nielsen Norman Group — Progress Indicators](https://www.nngroup.com/articles/progress-indicators/): feedback progres membantu menjelaskan status sistem dan mengurangi ketidakpastian saat menunggu. Startup menampilkan nama tahap, persentase, progress bar dan perubahan penanda tahap.

Semua halaman di atas berhasil diakses pada 6 Oktober 2026. Salinan hasil pembacaan tersedia pada folder `research` di workspace.

## Keputusan desain

Tema **Studio** memakai latar slate gelap, teks putih lembut, aksen mint dan status berwarna sesuai makna. Warna ikon tetap bervariasi. Ornamen benteng, garis kilau berlebihan, judul pelangi dan partikel default dihilangkan dari area kerja.

Tab tetap **chunky horizontal**, dengan kedalaman ringan 3 px, ikon 20 px, label terbaca, lebar sesuai teks, dan penanda aktif kecil. Tinggi navigasi 56–60 px. Scroll dipakai agar semua tab tidak dipadatkan atau dibungkus menjadi banyak baris.

Jendela awal tetap 760×520 dan logo header 22 px. Header normal 62 px; header pendek 46 px menyembunyikan deskripsi. Pada layar sempit, pencarian memiliki baris sendiri. Pada layar lebar, pencarian berada di kanan dengan ruang judul yang dihitung terpisah.

Kolom konten mengikuti lebar halaman: dua kolom saat cukup, satu kolom saat sempit. Kartu angka menjadi 68 px; kartu multiline 100 px. Ikon panel 24 px, outline 1 px dan bayangan ringan.

Statistik opsional dipindahkan ke footer tanpa nama brand kedua. Footer menyisakan ruang untuk statistik; statistik disembunyikan pada jendela sempit. Tombol mengambang memakai monogram P dengan target touch 44 px.

## Opening original — Pixel Assembly

Monogram P dirakit dari kotak pixel kecil. Logo berada di tengah kartu yang bersih, diikuti nama PixeL UI, subtitle, nama tahap, progress bar dan empat penanda: Antarmuka → Ikon → Ruang kerja → Siap.

Durasi nominal 7,5 detik berasal dari permintaan pengguna. Progres menggambarkan urutan startup UI; pekerjaan inisialisasi nyata tetap ditunggu sebelum jendela dibuka. Jika setup lebih lambat, opening dapat berlangsung lebih lama. `IntroDuration`, `Intro = false` dan Reduced Motion tetap didukung. Kartu opening dihitung agar muat pada viewport kecil.

## Validasi

- Luau compiler untuk library, Loot To Forge dan kedua contoh loader.
- Tes mock untuk header dan pencarian, dua kolom touch landscape, reflow portrait, kartu compact, footer statistik, scroll tab, pergantian bahasa, animasi, ikon dan cleanup.
- Opening dijalankan dengan clock virtual: durasi nominal 7,5 detik; ukuran kartu diperiksa pada viewport kecil.
- API lama, option ID, config dan 96 ikon dipertahankan.

Workspace tidak menyediakan runtime Roblox. Tes geometry dan mock memeriksa regresi yang tampak pada screenshot, tetapi bukan bukti hasil render langsung atau performa dalam game.
