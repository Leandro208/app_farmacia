import 'dart:convert';
import 'package:app_farmacia/model/categoria_medicamento.dart';
import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:app_farmacia/screens/validacao.dart';
import 'package:app_farmacia/service/anexo_service.dart';
import 'package:app_farmacia/utils/app_routes.dart';
import 'package:app_farmacia/utils/tipo_arquivo_enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormProduto extends StatefulWidget {
  const FormProduto({super.key});

  @override
  State<FormProduto> createState() => _FormProdutoState();
}

class _FormProdutoState extends State<FormProduto> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _estoqueFocus = FocusNode();
  CategoriaMedicamento? _categoriaSelecionada;
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final _validadeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _validadeController.text = DateFormat('dd/MM/yyyy').format(picked);
        _formData['validade'] = picked;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final produto = arg as Produto;
        _formData['id'] = produto.id;
        _formData['nome'] = produto.nome;
        _formData['categoria'] = produto.categoria;
        _formData['preco'] = produto.preco;
        _formData['validade'] = produto.validade;
        _formData['estoque'] = produto.estoque;
        _formData['fornecedor'] = produto.fornecedor;
        _formData['base64Imagem'] = produto.base64Imagem ?? '';
        _categoriaSelecionada = produto.categoria;
        _validadeController.text =
            DateFormat('dd/MM/yyyy').format(produto.validade);
      }
    }
  }

  @override
  void dispose() {
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _estoqueFocus.dispose();
    _validadeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    _formData['categoria'] = _categoriaSelecionada!;

    Provider.of<FarmaciaProvider>(
      context,
      listen: false,
    ).saveProduto(_formData).then((value) {
      Navigator.pushNamed(context, AppRoutes.HOME);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: _formData['base64Imagem'] != null &&
                              (_formData['base64Imagem'] as String).isNotEmpty
                          ? Image.memory(
                              base64Decode(_formData['base64Imagem'] as String))
                          : const Icon(Icons.image_not_supported),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(style: BorderStyle.none),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        isDismissible: true,
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) => _buildAnexoPopup(),
                      );
                    },
                    child: const Text('Cadastrar foto'),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _formData['nome']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
                onSaved: (nome) => _formData['nome'] = nome ?? '',
                validator: ValidaFormProdutos.validaCampo,
              ),
              DropdownButtonFormField<CategoriaMedicamento>(
                value: _categoriaSelecionada,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: CategoriaMedicamento.values
                    .map((CategoriaMedicamento categoria) {
                  return DropdownMenuItem<CategoriaMedicamento>(
                    value: categoria,
                    child: Text(categoria.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (CategoriaMedicamento? newValue) {
                  setState(() {
                    _categoriaSelecionada = newValue;
                  });
                },
                validator: ValidaFormProdutos.validaCampo,
              ),
              TextFormField(
                initialValue: _formData['preco']?.toString(),
                decoration: const InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (preco) =>
                    _formData['preco'] = double.parse(preco ?? '0'),
                validator: (precoValidator) {
                  final precoString = precoValidator ?? '';
                  final preco = double.tryParse(precoString) ?? -1;

                  if (preco <= 0) {
                    return 'Informe um preço válido.';
                  }

                  return null;
                },
              ),
              TextFormField(
                  controller: _validadeController,
                  decoration: InputDecoration(
                    labelText: 'Validade',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  validator: ValidaFormProdutos.validaCampo),
              TextFormField(
                initialValue: _formData['fornecedor']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Fornecedor',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_estoqueFocus);
                },
                onSaved: (fornecedor) =>
                    _formData['fornecedor'] = fornecedor ?? '',
                validator: ValidaFormProdutos.validaCampo,
              ),
              TextFormField(
                initialValue: _formData['estoque']?.toString(),
                decoration: const InputDecoration(labelText: 'Estoque'),
                textInputAction: TextInputAction.done,
                focusNode: _estoqueFocus,
                keyboardType: TextInputType.number,
                onSaved: (estoque) =>
                    _formData['estoque'] = int.parse(estoque ?? '0'),
                validator: (estoqueValidator) {
                  final estoqueString = estoqueValidator ?? '';
                  final estoque = int.tryParse(estoqueString) ?? -1;

                  if (estoque < 0) {
                    return 'Informe uma quantidade de estoque válida.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Cadastrar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnexoPopup() => Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                final base64Imagem = await AnexoService()
                    .anexarImagem(TipoArquivo.galeria);
                if (base64Imagem != null) {
                  setState(() {
                    _formData['base64Imagem'] = base64Imagem;
                  });
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.photo,
                        size: 30,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Galeria',
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final base64Imagem = await AnexoService()
                    .anexarImagem(TipoArquivo.storage);
                if (base64Imagem != null) {
                  setState(() {
                    _formData['base64Imagem'] = base64Imagem;
                  });
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.archive,
                          size: 30,
                          color: Colors.orange,
                        ),
                      )),
                  const SizedBox(height: 10),
                  const Text(
                    'Arquivo',
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                final base64Imagem = await AnexoService()
                    .anexarImagem(TipoArquivo.camera);
                if (base64Imagem != null) {
                  setState(() {
                    _formData['base64Imagem'] = base64Imagem;
                  });
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.orange,
                        ),
                      )),
                  const SizedBox(height: 10),
                  const Text(
                    'Tirar foto',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
