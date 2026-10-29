import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Registrasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RegisterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 1. GlobalKey untuk Form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk Text Field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FocusNode untuk navigasi keyboard (Nama -> Email -> Password)
  final FocusNode _namaFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // State untuk input lainnya
  String? _jenisKelamin;
  String? _programStudi = 'Sistem Informasi';
  bool _setujuSyarat = false;

  final List<String> _listProdi = [
    'Sistem Informasi',
    'Teknik Informatika',
    'Bisnis Digital',
    'Teknik Komputer'
  ];

  @override
  void dispose() {
    // Bersihkan controller dan focus node saat widget dihancurkan
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _namaFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() {
    // 4. Validasi Checkbox Syarat & Ketentuan terlebih dahulu
    if (!_setujuSyarat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 2. Validasi Form (GlobalKey)
    if (_formKey.currentState!.validate()) {
      // 5. Tampilkan AlertDialog konfirmasi jika semua validasi lolos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi Data Registrasi'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Text>[
                  Text('Nama Lengkap : ${_namaController.text}'),
                  Text('Email        : ${_emailController.text}'),
                  Text('Jenis Kelamin: ${_jenisKelamin ?? "-"}'),
                  Text('Program Studi: ${_programStudi ?? "-"}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Kirim'),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registrasi Berhasil!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Reset form setelah berhasil submit (opsional)
                  _formKey.currentState!.reset();
                  setState(() {
                    _namaController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    _jenisKelamin = null;
                    _programStudi = 'Sistem Informasi';
                    _setujuSyarat = false;
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi Mahasiswa'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Field Nama Lengkap
              TextFormField(
                controller: _namaController,
                focusNode: _namaFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  // 3. Pindah focus ke Email saat tombol "next" ditekan
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Email
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  // 3. Pindah focus ke Password saat tombol "next" ditekan
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Email harus mengandung karakter "@"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Field Password
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _submitForm();
                },
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Radio Button Jenis Kelamin
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: _jenisKelamin,
                      onChanged: (value) {
                        setState(() {
                          _jenisKelamin = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: _jenisKelamin,
                      onChanged: (value) {
                        setState(() {
                          _jenisKelamin = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // DropdownButton Program Studi
              DropdownButtonFormField<String>(
                value: _programStudi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                items: _listProdi.map((String prodi) {
                  return DropdownMenuItem<String>(
                    value: prodi,
                    child: Text(prodi),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _programStudi = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Checkbox Syarat & Ketentuan
              CheckboxListTile(
                title: const Text('Saya menyetujui Syarat & Ketentuan yang berlaku'),
                value: _setujuSyarat,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? value) {
                  setState(() {
                    _setujuSyarat = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Tombol Daftar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Daftar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}