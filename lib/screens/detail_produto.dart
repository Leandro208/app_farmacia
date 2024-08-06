import 'dart:convert';
import 'dart:typed_data';

import 'package:app_farmacia/model/produto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalhesProduto extends StatelessWidget {
  const DetalhesProduto({super.key});

  @override
  Widget build(BuildContext context) {
    final Produto produto =
        ModalRoute.of(context)!.settings.arguments as Produto;
    
    // Decodificar a imagem base64 para exibir no CircleAvatar
    final String? base64Imagem = produto.base64Imagem;
    final Uint8List? imagemBytes = base64Imagem != null 
        ? base64Decode(base64Imagem) 
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: imagemBytes != null
                            ? MemoryImage(imagemBytes) 
                            : const NetworkImage(
                                'https://via.placeholder.com/150',
                              ) as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Nome'),
                      subtitle: Text(produto.nome),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Categoria'),
                      subtitle: Text(produto.categoria.toString()),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Validade'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(produto.validade)),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Preço'),
                      subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Fornecedor'),
                      subtitle: Text(produto.fornecedor),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Estoque'),
                      subtitle: Text(produto.estoque.toString()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
