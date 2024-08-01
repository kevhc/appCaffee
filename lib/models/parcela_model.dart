class Parcela {
  final String id;
  final int dni;
  final String finca;
  final String cafePro;
  final String cafeCreci;
  final int purma;
  final int bosque;
  final int panLlevar;
  final int pasto;
  final int haTotal;
  final int proAnterior;
  final int proEstimado;
  final int lote;
  final int ha;
  final int edad;
  final int proEstimado2;
  final int caturra;
  final int pache;
  final int catimor;
  final int catuai;
  final int typica;
  final int borbon;
  final int otro;
  final DateTime fecha;
  final int estado;

  Parcela({
    required this.id,
    required this.dni,
    required this.finca,
    required this.cafePro,
    required this.cafeCreci,
    required this.purma,
    required this.bosque,
    required this.panLlevar,
    required this.pasto,
    required this.haTotal,
    required this.proAnterior,
    required this.proEstimado,
    required this.lote,
    required this.ha,
    required this.edad,
    required this.proEstimado2,
    required this.caturra,
    required this.pache,
    required this.catimor,
    required this.catuai,
    required this.typica,
    required this.borbon,
    required this.otro,
    required this.fecha,
    required this.estado,
  });

  factory Parcela.fromJson(Map<String, dynamic> json) {
    return Parcela(
      id: json['_id'],
      dni: (json['dni'] as num).toInt(), // Conversión de num a int
      finca: json['finca'],
      cafePro: json['cafe_pro'],
      cafeCreci: json['cafe_creci'],
      purma: (json['purma'] as num).toInt(), // Conversión de num a int
      bosque: (json['bosque'] as num).toInt(), // Conversión de num a int
      panLlevar: (json['pan_llevar'] as num).toInt(), // Conversión de num a int
      pasto: (json['pasto'] as num).toInt(), // Conversión de num a int
      haTotal: (json['ha_total'] as num).toInt(), // Conversión de num a int
      proAnterior:
          (json['pro_anterior'] as num).toInt(), // Conversión de num a int
      proEstimado:
          (json['pro_estimado'] as num).toInt(), // Conversión de num a int
      lote: (json['lote'] as num).toInt(), // Conversión de num a int
      ha: (json['ha'] as num).toInt(), // Conversión de num a int
      edad: (json['edad'] as num).toInt(), // Conversión de num a int
      proEstimado2:
          (json['pro_estimado2'] as num).toInt(), // Conversión de num a int
      caturra: (json['caturra'] as num).toInt(), // Conversión de num a int
      pache: (json['pache'] as num).toInt(), // Conversión de num a int
      catimor: (json['catimor'] as num).toInt(), // Conversión de num a int
      catuai: (json['catuai'] as num).toInt(), // Conversión de num a int
      typica: (json['typica'] as num).toInt(), // Conversión de num a int
      borbon: (json['borbon'] as num).toInt(), // Conversión de num a int
      otro: (json['otro'] as num).toInt(), // Conversión de num a int
      fecha: DateTime.parse(json['fecha']),
      estado: (json['estado'] as num).toInt(), // Conversión de num a int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'dni': dni,
      'finca': finca,
      'cafe_pro': cafePro,
      'cafe_creci': cafeCreci,
      'purma': purma,
      'bosque': bosque,
      'pan_llevar': panLlevar,
      'pasto': pasto,
      'ha_total': haTotal,
      'pro_anterior': proAnterior,
      'pro_estimado': proEstimado,
      'lote': lote,
      'ha': ha,
      'edad': edad,
      'pro_estimado2': proEstimado2,
      'caturra': caturra,
      'pache': pache,
      'catimor': catimor,
      'catuai': catuai,
      'typica': typica,
      'borbon': borbon,
      'otro': otro,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
    };
  }
}
