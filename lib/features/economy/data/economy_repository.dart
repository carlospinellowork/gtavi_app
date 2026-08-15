import '../domain/property_model.dart';

abstract class EconomyRepository {
  Future<List<PropertyModel>> getProperties();
}

class MockEconomyRepository implements EconomyRepository {
  final List<PropertyModel> _properties = const [
    PropertyModel(
      id: 'prop_malibu',
      name: 'Malibu Club Vice',
      location: 'Ocean Drive, Vice Beach',
      purchasePrice: 12000000,
      incomePerHour: 45000,
      category: 'Entretenimento',
      description: 'A casa noturna mais famosa de Vice City. Gera receita constante com festas e VIPs.',
    ),
    PropertyModel(
      id: 'prop_garage',
      name: 'Biscayne Export Garages',
      location: 'Port Vice',
      purchasePrice: 6500000,
      incomePerHour: 28000,
      category: 'Veículos & Carga',
      description: 'Oficina clandestina e centro de desmanche de superesportivos para exportação.',
    ),
    PropertyModel(
      id: 'prop_starfish',
      name: 'Starfish Mansion & Docks',
      location: 'Starfish Island',
      purchasePrice: 25000000,
      incomePerHour: 85000,
      category: 'Imóveis de Luxo',
      description: 'Mansão com doca privativa para lanchas e helicóptero comercial.',
    ),
    PropertyModel(
      id: 'prop_sunshine',
      name: 'Sunshine Autos Dealer',
      location: 'Little Haiti / Vice Port',
      purchasePrice: 8000000,
      incomePerHour: 32000,
      category: 'Concessionária',
      description: 'Concessionária de seminovos e carros raros com corridas ilegais nos fundos.',
    ),
    PropertyModel(
      id: 'prop_printworks',
      name: 'Vice Printworks & Logistics',
      location: 'Little Havana',
      purchasePrice: 15000000,
      incomePerHour: 60000,
      category: 'Logística',
      description: 'Gráfica comercial que serve de fachada para operações financeiras de grande porte.',
    ),
  ];

  @override
  Future<List<PropertyModel>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _properties;
  }
}
