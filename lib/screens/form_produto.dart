import 'package:app_farmacia/model/categoria_medicamento.dart';
import 'package:app_farmacia/model/farmacia_provider.dart';
import 'package:app_farmacia/model/produto.dart';
import 'package:app_farmacia/screens/validacao.dart';
import 'package:app_farmacia/utils/app_routes.dart';
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
  final _formData = Map<String, Object>();
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
        _categoriaSelecionada = produto.categoria;
        _validadeController.text = DateFormat('dd/MM/yyyy').format(produto.validade);
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
    print('${_formData['nome']} - ${_formData['categoria']} - ${_formData['preco']} - ${_formData['validade']} - ${_formData['estoque']} - ${_formData['fornecedor']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['nome']?.toString(),
                decoration: InputDecoration(
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
                decoration: InputDecoration(labelText: 'Categoria'),
                items: CategoriaMedicamento.values.map((CategoriaMedicamento categoria) {
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
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
                onSaved: (preco) =>
                    _formData['preco'] = double.parse(preco ?? '0'),
                validator: ValidaFormProdutos.validaCampo,
              ),
              TextFormField(
                controller: _validadeController,
                decoration: InputDecoration(
                  labelText: 'Validade',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: ValidaFormProdutos.validaCampo
              ),
              TextFormField(
                initialValue: _formData['fornecedor']?.toString(),
                decoration: InputDecoration(
                  labelText: 'Fornecedor',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_estoqueFocus);
                },
                onSaved: (fornecedor) => _formData['fornecedor'] = fornecedor ?? '',
                validator: ValidaFormProdutos.validaCampo,
              ),
              TextFormField(
                initialValue: _formData['estoque']?.toString(),
                decoration: InputDecoration(labelText: 'Estoque'),
                textInputAction: TextInputAction.done,
                focusNode: _estoqueFocus,
                keyboardType: TextInputType.number,
                onSaved: (estoque) =>
                    _formData['estoque'] = int.parse(estoque ?? '0'),
                validator: ValidaFormProdutos.validaCampo,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Cadastrar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
