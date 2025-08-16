import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

class AdvancedMapScreen extends StatefulWidget {
  @override
  _AdvancedMapScreenState createState() => _AdvancedMapScreenState();
}


class _AdvancedMapScreenState extends State<AdvancedMapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _markerAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _markerScaleAnimation;
  late Animation<double> _markerRotationAnimation;
  late Animation<double> _fabSlideAnimation;
  
  bool _isDarkMode = false;
  double _currentZoom = 13.0;
  String _selectedMapStyle = 'standard';
  bool _showTraffic = false;
  bool _show3D = false;

  final List<MapStyle> _mapStyles = [
    MapStyle('standard', 'Standard', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
    MapStyle('dark', 'Dark Mode', 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'),
    MapStyle('satellite', 'Satellite', 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'),
    MapStyle('terrain', 'Terrain', 'https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg'),
  ];

  final List<CustomMarker> _customMarkers = [
    CustomMarker(
      point: LatLng(5.3599517, -4.0082563),
      title: 'Abidjan Centre',
      subtitle: 'Cœur économique de la Côte d\'Ivoire',
      icon: Icons.business,
      color: Color(0xFF4CAF50),
    ),
    CustomMarker(
      point: LatLng(5.3700, -4.0100),
      title: 'Plateau',
      subtitle: 'Quartier d\'affaires',
      icon: Icons.apartment,
      color: Color(0xFF2196F3),
    ),
    CustomMarker(
      point: LatLng(5.3500, -4.0000),
      title: 'Port d\'Abidjan',
      subtitle: 'Premier port d\'Afrique de l\'Ouest',
      icon: Icons.anchor,
      color: Color(0xFFFF9800),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _markerAnimationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _markerScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _markerAnimationController,
      curve: Curves.elasticOut,
    ));

    _markerRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _markerAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabSlideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.bounceOut,
    ));

    _markerAnimationController.forward();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _markerAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF1A1A1A) : Colors.grey[100],
      body: Stack(
        children: [
          // Carte principale SANS effet de glassmorphisme qui cause le flou
          Container(
            margin: EdgeInsets.all(16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // Suppression des box shadows qui peuvent causer du flou
            ),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(5.3599517, -4.0082563),
                initialZoom: _currentZoom,
                minZoom: 8.0,
                maxZoom: 18.0,
                onTap: (tapPosition, point) => _onMapTap(point),
                onPositionChanged: (position, hasGesture) {
                  setState(() {
                    _currentZoom = position.zoom;
                  });
                },
                // Amélioration des performances de rendu
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                // Couche de tuiles optimisée
                TileLayer(
                  urlTemplate: _getSelectedMapStyle().urlTemplate,
                  userAgentPackageName: 'com.example.advanced_map',
                  maxZoom: 19,
                  // Configurations importantes pour éviter le flou
                  tileSize: 256, // Taille standard des tuiles
                  zoomReverse: false,
                  // Amélioration du cache et du rendu
                  maxNativeZoom: 19,
                  additionalOptions: {
                    'attribution': '© OpenStreetMap contributors',
                  },
                  // Amélioration de la qualité d'affichage
                  tileBuilder: (context, tileWidget, tile) {
                    return ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      ),
                      child: tileWidget,
                    );
                  },
                ),
                
                // Couche de marqueurs animés
                MarkerLayer(
                  markers: _buildAnimatedMarkers(),
                ),
                
                // Couche de cercles indicateurs
                CircleLayer(
                  circles: _buildCircleIndicators(),
                ),
                
                // Couche de polylignes pour les connexions
                PolylineLayer(
                  polylines: _buildConnectionLines(),
                ),
              ],
            ),
          ),
          
          // Interface utilisateur flottante
          _buildFloatingUI(),
          
          // Panneau de contrôles
          _buildControlPanel(),
          
          // Indicateur de zoom
          _buildZoomIndicator(),
          
          // Boutons d'action flottants
          _buildFloatingActionButtons(),
        ],
      ),
    );
  }

  List<Marker> _buildAnimatedMarkers() {
    return _customMarkers.map((customMarker) {
      return Marker(
        point: customMarker.point,
        width: 80,
        height: 80,
        child: AnimatedBuilder(
          animation: _markerAnimationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _markerScaleAnimation.value,
              child: Transform.rotate(
                angle: _markerRotationAnimation.value * 0.1,
                child: GestureDetector(
                  onTap: () => _showMarkerDetails(customMarker),
                  child: Container(
                    decoration: BoxDecoration(
                      color: customMarker.color.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: customMarker.color.withOpacity(0.4),
                          blurRadius: 8, // Réduction du flou
                          spreadRadius: 2, // Réduction de l'étalement
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white,
                        width: 2, // Réduction de l'épaisseur
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          customMarker.icon,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(height: 2),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            customMarker.title.split(' ').first,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  List<CircleMarker> _buildCircleIndicators() {
    return _customMarkers.map((marker) {
      return CircleMarker(
        point: marker.point,
        radius: 100,
        color: marker.color.withOpacity(0.1),
        borderColor: marker.color.withOpacity(0.3),
        borderStrokeWidth: 1, // Réduction de l'épaisseur
      );
    }).toList();
  }

  List<Polyline> _buildConnectionLines() {
    List<Polyline> lines = [];
    for (int i = 0; i < _customMarkers.length - 1; i++) {
      lines.add(
        Polyline(
          points: [
            _customMarkers[i].point,
            _customMarkers[i + 1].point,
          ],
          strokeWidth: 2, // Réduction de l'épaisseur
          color: Colors.blue.withOpacity(0.6),
          pattern: StrokePattern.dotted(),
        ),
      );
    }
    return lines;
  }

  Widget _buildFloatingUI() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (_isDarkMode ? Colors.black : Colors.white).withOpacity(0.95), // Augmentation de l'opacité
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10, // Réduction du flou
              offset: Offset(0, 3), // Réduction de l'offset
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_city,
              color: Color(0xFF4CAF50),
              size: 28,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abidjan Explorer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Découvrez la perle des lagunes',
                    style: TextStyle(
                      fontSize: 12,
                      color: (_isDarkMode ? Colors.white : Colors.black87).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
              activeColor: Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Positioned(
      top: 140,
      right: 20,
      child: AnimatedBuilder(
        animation: _fabAnimationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_fabSlideAnimation.value, 0),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                color: (_isDarkMode ? Colors.black : Colors.white).withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8, // Réduction du flou
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildControlButton(
                    Icons.add,
                    () => _mapController.move(
                      _mapController.camera.center,
                      _currentZoom + 1,
                    ),
                  ),
                  Divider(height: 1),
                  _buildControlButton(
                    Icons.remove,
                    () => _mapController.move(
                      _mapController.camera.center,
                      _currentZoom - 1,
                    ),
                  ),
                  Divider(height: 1),
                  _buildControlButton(
                    Icons.my_location,
                    () => _centerOnAbidjan(),
                  ),
                  Divider(height: 1),
                  _buildControlButton(
                    Icons.layers,
                    () => _showMapStyleSelector(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 50,
          child: Icon(
            icon,
            color: _isDarkMode ? Colors.white : Colors.black87,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _buildZoomIndicator() {
    return Positioned(
      bottom: 100,
      left: 20,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF4CAF50).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6, // Réduction du flou
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Zoom: ${_currentZoom.toStringAsFixed(1)}x',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Positioned(
      bottom: 30,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "traffic",
            mini: true,
            backgroundColor: _showTraffic ? Color(0xFFFF5722) : Color(0xFF757575),
            onPressed: () {
              setState(() {
                _showTraffic = !_showTraffic;
              });
            },
            child: Icon(Icons.traffic, color: Colors.white),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "3d",
            mini: true,
            backgroundColor: _show3D ? Color(0xFF9C27B0) : Color(0xFF757575),
            onPressed: () {
              setState(() {
                _show3D = !_show3D;
              });
            },
            child: Icon(Icons.view_in_ar, color: Colors.white),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "refresh",
            backgroundColor: Color(0xFF4CAF50),
            onPressed: () {
              _markerAnimationController.reset();
              _markerAnimationController.forward();
            },
            child: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _onMapTap(LatLng point) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Position: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMarkerDetails(CustomMarker marker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: marker.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(marker.icon, color: Colors.white, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marker.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        marker.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: (_isDarkMode ? Colors.white : Colors.black87).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _mapController.move(marker.point, 16.0);
              },
              icon: Icon(Icons.navigation),
              label: Text('Naviguer vers ce lieu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: marker.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _centerOnAbidjan() {
    _mapController.move(LatLng(5.3599517, -4.0082563), 13.0);
  }

  void _showMapStyleSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _isDarkMode ? Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Style de carte',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            ..._mapStyles.map((style) => ListTile(
              leading: Icon(
                Icons.map,
                color: _selectedMapStyle == style.id ? Color(0xFF4CAF50) : Colors.grey,
              ),
              title: Text(
                style.name,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              trailing: _selectedMapStyle == style.id
                  ? Icon(Icons.check, color: Color(0xFF4CAF50))
                  : null,
              onTap: () {
                setState(() {
                  _selectedMapStyle = style.id;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  MapStyle _getSelectedMapStyle() {
    return _mapStyles.firstWhere((style) => style.id == _selectedMapStyle);
  }
}

class CustomMarker {
  final LatLng point;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  CustomMarker({
    required this.point,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class MapStyle {
  final String id;
  final String name;
  final String urlTemplate;

  MapStyle(this.id, this.name, this.urlTemplate);
}