// presentation/screens/map/bangladesh_map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';



class BangladeshStaticMapScreen extends StatefulWidget {
  const BangladeshStaticMapScreen({super.key});

  @override
  State<BangladeshStaticMapScreen> createState() => _BangladeshStaticMapScreenState();
}

class _BangladeshStaticMapScreenState extends State<BangladeshStaticMapScreen> {
  DistrictData? _selectedDistrict;
  String? _hoveredDistrict;

  final List<DistrictData> _districts = BangladeshDistricts.getAllDistricts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black87,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bangladesh Environmental Issues',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Map Area
                Container(
                  height: 450.h,
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF1A1A2E),
                              const Color(0xFF16213E),
                            ]
                          : [
                              const Color(0xFFE3F2FD),
                              const Color(0xFFBBDEFB),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: AppColors.neonBlue.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Map Title
                      Positioned(
                        top: 16.h,
                        left: 16.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black54
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.neonGreen.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.neonGreen,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Bangladesh',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // District Markers
                      ..._buildDistrictMarkers(isDark),

                      // Legend
                      Positioned(
                        top: 16.h,
                        right: 16.w,
                        child: _buildLegend(isDark),
                      ),
                    ],
                  ),
                ),

                // District List
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select a District',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ..._districts.map((district) {
                        return _buildDistrictCard(district, isDark);
                      }).toList(),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet for Selected District
          if (_selectedDistrict != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildDistrictInfoPanel(_selectedDistrict!, isDark),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildDistrictMarkers(bool isDark) {
    // Positioned markers for each district on the map
    final markers = <String, Map<String, dynamic>>{
      'Dhaka': {'top': 200.h, 'left': 180.w},
      'Chittagong': {'top': 280.h, 'left': 280.w},
      'Khulna': {'top': 300.h, 'left': 100.w},
      'Sylhet': {'top': 120.h, 'left': 250.w},
      'Rajshahi': {'top': 180.h, 'left': 80.w},
      'Rangpur': {'top': 80.h, 'left': 120.w},
    };

    return _districts.map((district) {
      final position = markers[district.name];
      if (position == null) return const SizedBox.shrink();

      final isHovered = _hoveredDistrict == district.name;
      final isSelected = _selectedDistrict?.name == district.name;

      Color markerColor;
      if (district.severityLevel == 'High') {
        markerColor = Colors.red;
      } else if (district.severityLevel == 'Medium') {
        markerColor = Colors.orange;
      } else {
        markerColor = Colors.green;
      }

      return Positioned(
        top: position['top'],
        left: position['left'],
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedDistrict = district;
            });
          },
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoveredDistrict = district.name;
              });
            },
            onExit: (_) {
              setState(() {
                _hoveredDistrict = null;
              });
            },
            child: AnimatedScale(
              scale: isHovered || isSelected ? 1.3 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: markerColor.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: markerColor.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.location_city,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  if (isHovered || isSelected) ...[
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black87 : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        district.name,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLegend(bool isDark) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.neonBlue.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Severity',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          _buildLegendItem('High', Colors.red, isDark),
          SizedBox(height: 4.h),
          _buildLegendItem('Medium', Colors.orange, isDark),
          SizedBox(height: 4.h),
          _buildLegendItem('Low', Colors.green, isDark),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildDistrictCard(DistrictData district, bool isDark) {
    final isSelected = _selectedDistrict?.name == district.name;

    Color severityColor;
    if (district.severityLevel == 'High') {
      severityColor = Colors.red;
    } else if (district.severityLevel == 'Medium') {
      severityColor = Colors.orange;
    } else {
      severityColor = Colors.green;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDistrict = district;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    severityColor.withOpacity(0.3),
                    severityColor.withOpacity(0.1),
                  ]
                : [
                    (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                    (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? severityColor.withOpacity(0.5)
                : (isDark ? Colors.white : Colors.black).withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.location_city,
                color: severityColor,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    district.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Population: ${district.population}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: severityColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${district.problems.length} Problems',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: severityColor.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          district.severityLevel,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.white38 : Colors.black38,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistrictInfoPanel(DistrictData district, bool isDark) {
    return Container(
      constraints: BoxConstraints(maxHeight: 500.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF16213E),
                ]
              : [
                  Colors.white,
                  Colors.grey[50]!,
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black26,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.neonGreen, AppColors.neonBlue],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.location_city,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        district.name,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Population: ${district.population}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedDistrict = null;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Problems List
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              shrinkWrap: true,
              itemCount: district.problems.length,
              itemBuilder: (context, index) {
                final problem = district.problems[index];
                return _buildProblemCard(problem, isDark);
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildProblemCard(Problem problem, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            problem.severityColor.withOpacity(0.2),
            problem.severityColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: problem.severityColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: problem.severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  problem.icon,
                  color: problem.severityColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      problem.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: problem.severityColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        problem.severity,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            problem.description,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.white70 : Colors.black54,
              height: 1.4,
            ),
          ),
          if (problem.affectedAreas.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: problem.affectedAreas.map((area) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    area,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// Updated DistrictData class with severityLevel as String
class DistrictData {
  final String name;
  final LatLng location;
  final String population;
  final List<Problem> problems;
  final String severityLevel;

  DistrictData({
    required this.name,
    required this.location,
    required this.population,
    required this.problems,
    required this.severityLevel,
  });
}

class Problem {
  final String title;
  final String description;
  final String severity;
  final Color severityColor;
  final IconData icon;
  final List<String> affectedAreas;

  Problem({
    required this.title,
    required this.description,
    required this.severity,
    required this.severityColor,
    required this.icon,
    this.affectedAreas = const [],
  });
}

class BangladeshDistricts {
  static List<DistrictData> getAllDistricts() {
    return [
      // Dhaka
      DistrictData(
        name: 'Dhaka',
        location: const LatLng(23.8103, 90.4125),
        population: '21.7 million',
        severityLevel: 'High',
        problems: [
          Problem(
            title: 'Water Pollution',
            description:
                'Severe water pollution affecting major rivers including Buriganga, Turag, Balu, and Shitalakshya. Industrial waste and untreated sewage contaminate drinking water sources.',
            severity: 'HIGH',
            severityColor: Colors.red,
            icon: Icons.water_drop,
            affectedAreas: [
              'Buriganga River',
              'Turag River',
              'Balu River',
              'Shitalakshya River'
            ],
          ),
          Problem(
            title: 'Traffic Congestion',
            description:
                'Chronic traffic jams throughout the city, especially during peak hours. Average commute time can exceed 2-3 hours for short distances.',
            severity: 'HIGH',
            severityColor: Colors.red,
            icon: Icons.traffic,
            affectedAreas: [
              'Farmgate',
              'Mohakhali',
              'Gulshan',
              'Motijheel',
              'Shahbag'
            ],
          ),
          Problem(
            title: 'Air Pollution',
            description:
                'Consistently ranks among the world\'s most polluted cities. Construction dust, vehicle emissions, and industrial pollution create hazardous air quality.',
            severity: 'HIGH',
            severityColor: Colors.red,
            icon: Icons.air,
            affectedAreas: ['City-wide', 'Tejgaon Industrial Area'],
          ),
          Problem(
            title: 'Overpopulation',
            description:
                'Extreme population density of over 23,000 people per square kilometer. Limited housing, sanitation facilities, and public services.',
            severity: 'HIGH',
            severityColor: Colors.red,
            icon: Icons.groups,
            affectedAreas: ['Mirpur', 'Mohammadpur', 'Old Dhaka'],
          ),
          Problem(
            title: 'Waste Management',
            description:
                'Inadequate waste disposal systems. About 3,000 tons of solid waste generated daily with limited recycling infrastructure.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.delete_outline,
            affectedAreas: ['Matuail Landfill', 'City Streets'],
          ),
        ],
      ),

      // Chittagong
      DistrictData(
        name: 'Chittagong',
        location: const LatLng(22.3569, 91.7832),
        population: '8.4 million',
        severityLevel: 'Medium',
        problems: [
          Problem(
            title: 'Port Congestion',
            description:
                'Heavy congestion at Chittagong Port affects trade efficiency. Container handling delays and limited storage capacity.',
            severity: 'HIGH',
            severityColor: Colors.orange,
            icon: Icons.directions_boat,
            affectedAreas: ['Chittagong Port', 'Port Access Roads'],
          ),
          Problem(
            title: 'Hill Cutting',
            description:
                'Illegal hill cutting for real estate development causing landslides, environmental degradation, and loss of natural habitat.',
            severity: 'HIGH',
            severityColor: Colors.red,
            icon: Icons.landscape,
            affectedAreas: ['Foy\'s Lake', 'Batali Hill', 'Tiger Pass'],
          ),
          Problem(
            title: 'Water Shortage',
            description:
                'Growing water scarcity during dry season. Increasing demand from population and industries exceeds supply.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.water,
            affectedAreas: ['Halishahar', 'Bayezid', 'Patenga'],
          ),
          Problem(
            title: 'Industrial Pollution',
            description:
                'Pollution from shipbreaking yards and textile industries affects air and water quality.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.factory,
            affectedAreas: ['Sitakunda', 'Kadamtali', 'EPZ Area'],
          ),
        ],
      ),

      // Khulna
      DistrictData(
        name: 'Khulna',
        location: const LatLng(22.8456, 89.5403),
        population: '2.3 million',
        severityLevel: 'Medium',
        problems: [
          Problem(
            title: 'Salinity Intrusion',
            description:
                'Rising sea levels and reduced freshwater flow causing saltwater intrusion into agricultural lands and drinking water sources.',
            severity: 'HIGH',
            severityColor: Colors.red,
            icon: Icons.waves,
            affectedAreas: [
              'Paikgacha',
              'Koyra',
              'Dacope',
              'Coastal Villages'
            ],
          ),
          Problem(
            title: 'Waterlogging',
            description:
                'Severe waterlogging during monsoon season due to poor drainage systems and tidal influences. Affects thousands of residents.',
            severity: 'HIGH',
            severityColor: Colors.orange,
            icon: Icons.flood,
            affectedAreas: [
              'Old Khulna',
              'Khalishpur',
              'Sonadanga',
              'Labanchara'
            ],
          ),
          Problem(
            title: 'Cyclone Vulnerability',
            description:
                'High risk area for tropical cyclones. Inadequate early warning systems and cyclone shelters in some regions.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.storm,
            affectedAreas: ['Sundarbans Area', 'Coastal Belt'],
          ),
          Problem(
            title: 'Mangrove Depletion',
            description:
                'Degradation of Sundarbans mangrove forest due to illegal logging and shrimp farming affecting biodiversity.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.park,
            affectedAreas: ['Sundarbans', 'Satkhira Border'],
          ),
        ],
      ),

      // Sylhet
      DistrictData(
        name: 'Sylhet',
        location: const LatLng(24.8949, 91.8687),
        population: '3.9 million',
        severityLevel: 'Low',
        problems: [
          Problem(
            title: 'Flash Flooding',
            description:
                'Frequent flash floods during monsoon affecting haor areas. Submergence damages crops and disrupts communication.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.flood,
            affectedAreas: ['Sunamganj Haor', 'Companiganj', 'Bishwanath'],
          ),
          Problem(
            title: 'Stone Extraction',
            description:
                'Unregulated stone extraction from rivers causing environmental damage and affecting river flow patterns.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.construction,
            affectedAreas: ['Jaflong', 'Gowainghat', 'Border Areas'],
          ),
          Problem(
            title: 'Deforestation',
            description:
                'Loss of forest cover due to tea estate expansion and settlements. Threatens biodiversity and water retention.',
            severity: 'LOW',
            severityColor: Colors.green,
            icon: Icons.forest,
            affectedAreas: ['Lawachara Forest', 'Tea Gardens'],
          ),
        ],
      ),

      // Rajshahi
      DistrictData(
        name: 'Rajshahi',
        location: const LatLng(24.3745, 88.6042),
        population: '2.6 million',
        severityLevel: 'Low',
        problems: [
          Problem(
            title: 'River Erosion',
            description:
                'Padma River erosion displacing thousands of families annually. Loss of agricultural land and infrastructure.',
            severity: 'HIGH',
            severityColor: Colors.red,
            icon: Icons.landslide,
            affectedAreas: ['Godagari', 'Charghat', 'Padma Riverbank'],
          ),
          Problem(
            title: 'Water Scarcity',
            description:
                'Severe water shortage during dry season. Groundwater depletion and reduced river flow affect agriculture.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.water_drop_outlined,
            affectedAreas: ['Paba', 'Mohanpur', 'Bagha'],
          ),
          Problem(
            title: 'Drought',
            description:
                'Periodic drought conditions affecting agriculture and food security. Limited irrigation infrastructure.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.wb_sunny,
            affectedAreas: ['Barind Tract', 'Rural Areas'],
          ),
        ],
      ),

      // Rangpur
      DistrictData(
        name: 'Rangpur',
        location: const LatLng(25.7439, 89.2752),
        population: '2.9 million',
        severityLevel: 'Low',
        problems: [
          Problem(
            title: 'Poverty',
            description:
                'Higher poverty rates compared to national average. Limited employment opportunities and seasonal food insecurity.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.money_off,
            affectedAreas: ['Kurigram', 'Gaibandha', 'Rural Districts'],
          ),
          Problem(
            title: 'River Erosion',
            description:
                'Teesta and Brahmaputra river erosion causing displacement and loss of agricultural land.',
            severity: 'MEDIUM',
            severityColor: Colors.orange,
            icon: Icons.waves,
            affectedAreas: ['Teesta Riverbank', 'Char Areas'],
          ),
          Problem(
            title: 'Food Security',
            description:
                'Seasonal food insecurity especially during "Monga" period. Limited storage and market access.',
            severity: 'LOW',
            severityColor: Colors.green,
            icon: Icons.restaurant,
            affectedAreas: ['Northern Districts', 'Char Lands'],
          ),
        ],
      ),
    ];
  }
}