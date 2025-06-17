import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
/// Modelo de dados para resposta da API Open-Meteo (https://api.open-meteo.com/v1/forecast)
/// Contém temperatura atual, localização e índice UV.
class Weather {
  final double temperature;
  final double humidity;
  final double tempMax;
  final double tempMin;
  final int weatherCode;
  final String location;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
    required this.location,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final temperature = (json['current_weather']?['temperature'] ?? 0).toDouble();
    final weatherCode = (json['current_weather']?['weathercode'] ?? 0).toInt();
    final daily = json['daily'] ?? {};
    final tempMaxList = daily['temperature_2m_max'] as List?;
    final tempMinList = daily['temperature_2m_min'] as List?;
    final tempMax = (tempMaxList != null && tempMaxList.isNotEmpty)
        ? (tempMaxList[0] as num).toDouble()
        : 0.0;
    final tempMin = (tempMinList != null && tempMinList.isNotEmpty)
        ? (tempMinList[0] as num).toDouble()
        : 0.0;
    final humidity = (json['current']?['relative_humidity_2m'] ?? 0).toDouble();
    return Weather(
      temperature: temperature,
      humidity: humidity,
      tempMax: tempMax,
      tempMin: tempMin,
      weatherCode: weatherCode,
      location: 'São Paulo, Brasil',
    );
  }

  factory Weather.fromJsonWithLocation(Map<String, dynamic> json, String customLocation) {
    final temperature = (json['current_weather']?['temperature'] ?? 0).toDouble();
    final weatherCode = (json['current_weather']?['weathercode'] ?? 0).toInt();
    final daily = json['daily'] ?? {};
    final tempMaxList = daily['temperature_2m_max'] as List?;
    final tempMinList = daily['temperature_2m_min'] as List?;
    final tempMax = (tempMaxList != null && tempMaxList.isNotEmpty)
        ? (tempMaxList[0] as num).toDouble()
        : 0.0;
    final tempMin = (tempMinList != null && tempMinList.isNotEmpty)
        ? (tempMinList[0] as num).toDouble()
        : 0.0;
    final humidity = (json['current']?['relative_humidity_2m'] ?? 0).toDouble();
    return Weather(
      temperature: temperature,
      humidity: humidity,
      tempMax: tempMax,
      tempMin: tempMin,
      weatherCode: weatherCode,
      location: customLocation,
    );
  }

  /// Busca dados do clima com geolocalização automática
  static Future<Weather> fetchWeatherWithLocation() async {
    try {
      // Tenta obter localização atual
      Position? position = await _getCurrentLocation();
      
      if (position != null) {
        // Busca nome da cidade
        String cityName = await _getCityNameFromCoordinates(
          position.latitude, 
          position.longitude
        );
        
        // Busca clima com coordenadas reais
        return await _fetchWeatherData(
          position.latitude, 
          position.longitude, 
          cityName
        );
      } else {
        // Fallback para São Paulo
        return await _fetchWeatherData(-23.55, -46.63, "São Paulo, Brasil");
      }
    } catch (e) {
      print('[Weather] Erro: $e');
      // Fallback para São Paulo em caso de erro
      return await _fetchWeatherData(-23.55, -46.63, "São Paulo, Brasil");
    }
  }

  /// Obtém localização atual do usuário
  static Future<Position?> _getCurrentLocation() async {
    try {
      // Verifica se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('[Weather] Serviço de localização desabilitado');
        return null;
      }

      // Verifica e solicita permissão
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('[Weather] Permissão de localização negada');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('[Weather] Permissão de localização negada permanentemente');
        return null;
      }

      // Obtém a localização atual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      print('[Weather] Localização obtida: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('[Weather] Erro ao obter localização: $e');
      return null;
    }
  }

  /// Converte coordenadas em nome da cidade usando geocoding reverso
  static Future<String> _getCityNameFromCoordinates(double latitude, double longitude) async {
    try {
      // Usa a API Nominatim (OpenStreetMap) para geocoding reverso - GRATUITA
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));

      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': latitude,
          'lon': longitude,
          'accept-language': 'pt-BR,pt,en',
          'addressdetails': '1',
        },
        options: Options(
          headers: {
            'User-Agent': 'MetamorfoseApp/1.0.0', // Necessário para Nominatim
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        
        // Tenta pegar cidade, município ou região em ordem de prioridade
        String? city = data['address']?['city'] ??
                      data['address']?['town'] ??
                      data['address']?['village'] ??
                      data['address']?['municipality'] ??
                      data['address']?['county'];
        
        String? state = data['address']?['state'] ??
                       data['address']?['region'];
        
        String? country = data['address']?['country'];

        // Monta o nome da localização
        if (city != null) {
          if (state != null && country == 'Brasil') {
            // Se for no Brasil, mostra "Cidade, Estado"
            return "$city, $state";
          } else if (country != null) {
            // Se for em outro país, mostra "Cidade, País"
            return "$city, $country";
          } else {
            // Só a cidade
            return city;
          }
        } else if (state != null) {
          // Se não achou cidade, mas achou estado
          return state;
        }
      }
    } catch (e) {
      print('[Weather] Erro no geocoding: $e');
    }
    
    // Fallback
    return "Sua localização";
  }

  /// Busca dados do clima na API OpenMeteo
  static Future<Weather> _fetchWeatherData(double latitude, double longitude, String locationName) async {
    final dio = createDioWeatherApi();
    
    final response = await dio.get('forecast', queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'current_weather': true,
      'daily': 'temperature_2m_max,temperature_2m_min',
      'current': 'relative_humidity_2m',
      'hourly': 'uv_index',
      'timezone': 'auto', // Usa o timezone automático baseado na localização
    });
    
    if (response.statusCode == 200) {
      return Weather.fromJsonWithLocation(response.data, locationName);
    } else {
      throw Exception('Erro na API OpenMeteo: ${response.statusMessage}');
    }
  }

  /// Configuração do Dio para a API Open-Meteo
  static Dio createDioWeatherApi() {
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        baseUrl: 'https://api.open-meteo.com/v1/',
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('[OpenMeteo] Request: \\${options.method} \\${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        print('[OpenMeteo] Response: \\${response.statusCode}');
        if (response.statusCode == 200) {
          print('[OpenMeteo] Dados recebidos com sucesso');
        } else {
          print('[OpenMeteo] Erro na resposta: ${response.statusMessage}');
        }
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('[OpenMeteo] Error: \\${error.message}');
        return handler.next(error);
      },
    ));
    return dio;
  }

  /// Retorna o emoji correspondente ao weatherCode
  String getWeatherIcon() {
    const iconMap = {
      0: '☀️',
      1: '🌤️',
      2: '⛅',
      3: '☁️',
      45: '🌫️',
      48: '🌫️',
      51: '🌦️',
      53: '🌦️',
      55: '🌦️',
      61: '🌧️',
      63: '🌧️',
      65: '🌧️',
      71: '🌨️',
      73: '🌨️',
      75: '🌨️',
      77: '❄️',
      80: '🌦️',
      81: '🌧️',
      82: '🌧️',
      85: '🌨️',
      86: '🌨️',
      95: '⛈️',
      96: '⛈️',
      99: '⛈️',
    };
    return iconMap[weatherCode] ?? '❓';
  }
} 