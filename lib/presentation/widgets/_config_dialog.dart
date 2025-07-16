part of 'footer.dart';

class GridConfigDialog extends ConsumerStatefulWidget {
  const GridConfigDialog({super.key});

  @override
  ConsumerState<GridConfigDialog> createState() => _GridConfigDialogState();
}

class _GridConfigDialogState extends ConsumerState<GridConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  final _rowController = TextEditingController(text: '5');
  final _colController = TextEditingController(text: '5');

  void _applyConfig() {
    if (_formKey.currentState!.validate()) {
      final rows = int.parse(_rowController.text);
      final columns = int.parse(_colController.text);

      ref.read(gameProvider.notifier).resetGame(rows: rows, columns: columns);

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _rowController.dispose();
    _colController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Custom Grid Configuration'),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNumberField('Rows', _rowController),
          _buildNumberField('Columns', _colController),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: Navigator.of(context).pop,
        child: const Text('Cancel'),
      ),
      ElevatedButton(onPressed: _applyConfig, child: const Text('Start Game')),
    ],
  );

  Widget _buildNumberField(String label, TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            final number = int.tryParse(value ?? '');
            if (number == null || number < 2 || number > 99) {
              return 'Enter 2–99';
            }
            return null;
          },
        ),
      );
}
