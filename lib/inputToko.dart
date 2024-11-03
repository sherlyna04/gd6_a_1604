import 'package:flutter/material.dart';
import 'package:gd6_a_1604/database/sql_helper.dart';
import 'package:gd6_a_1604/entity/toko.dart';

class InputToko extends StatefulWidget {
  const InputToko({Key? key, required this.title, this.id, this.alamat, this.tahunDibuka}) : super(key: key);

  final String title;
  final int? id;
  final String? alamat;
  final String? tahunDibuka;

  @override
  State<InputToko> createState() => _InputTokoState();
}

class _InputTokoState extends State<InputToko> {
  final TextEditingController controllerAlamat = TextEditingController();
  final TextEditingController controllerTahun = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      controllerAlamat.text = widget.alamat ?? '';
      controllerTahun.text = widget.tahunDibuka ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controllerAlamat,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Alamat Toko',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controllerTahun,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Tahun Dibuka',
              ),
              keyboardType: TextInputType.text, // Mengubah keyboard type menjadi text
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () async {
                // Validasi input
                if (controllerAlamat.text.isEmpty || controllerTahun.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Harap isi semua field!')),
                  );
                  return;
                }

                try {
                  if (widget.id == null) {
                    await addStore();
                  } else {
                    await editStore(widget.id!);
                  }
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terjadi kesalahan: $e')),
                  );
                }
              },
              child: Text(widget.id == null ? 'Tambah' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addStore() async {
    await SQLHelper.addStore(controllerAlamat.text, controllerTahun.text); // Menggunakan String
  }

  Future<void> editStore(int id) async {
    await SQLHelper.editStore(id, controllerAlamat.text, controllerTahun.text); // Menggunakan String
  }
}
