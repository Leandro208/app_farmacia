import 'package:app_farmacia/model/produto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalhesProduto extends StatelessWidget {
  const DetalhesProduto({super.key});

  @override
  Widget build(BuildContext context) {
    final Produto produto =
        ModalRoute.of(context)!.settings.arguments as Produto;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${produto.nome}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Categoria: ${produto.categoria}'),
            SizedBox(height: 8),
            Text('Validade: ${DateFormat('dd/MM/yyyy').format(produto.validade)}'),
            SizedBox(height: 8),
            Text('Preço: ${produto.preco.toString()}'),
            SizedBox(height: 8),
            Text('Fornecedor: ${produto.fornecedor}'),
            SizedBox(height: 16),
            Text('Estoque: ${produto.estoque}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implemente a lógica para editar o produto
                    // Você pode navegar para uma tela de edição passando o produto como argumento
                  },
                  child: Text('Editar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implemente a lógica para remover o produto
                    // Você pode exibir um diálogo de confirmação antes de remover o produto
                  },
                  child: Text('Remover'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
