import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_faysal_game/core/utils/logger.dart';
import 'package:flutter_faysal_game/data/models/user_profile.dart';
import 'package:flutter_faysal_game/data/repositories/admin_repository.dart';
import 'package:flutter_faysal_game/data/repositories/home_repo.dart';
import 'package:flutter_faysal_game/presentation/screens/home/model/user_daily_task.dart';
import 'package:flutter_faysal_game/presentation/screens/home/model/usermodel.dart';
import 'package:flutter_faysal_game/services/cludinary_service.dart';
import 'package:flutter_faysal_game/services/localdata_service.dart';
import 'package:injectable/injectable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

@lazySingleton
class HomeProvider with ChangeNotifier {
  final LocalStorageService _localStorageService;
  final HomeRepository _homeRepository;

  // ────────────────────────────────────────────────
  // STATE
  // ────────────────────────────────────────────────

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? get profile => _profile;

  Map<String, dynamic>? _stats;
  Map<String, dynamic>? get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Location state
  String? _userDistrict;
  String? get userDistrict => _userDistrict;

  String? _userCity;
  String? get userCity => _userCity;

  String? _userCountry;
  String? get userCountry => _userCountry;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  bool _isLoadingLocation = false;
  bool get isLoadingLocation => _isLoadingLocation;

  HomeProvider(this._homeRepository, this._localStorageService) {
    _listenToProfileUpdates();
    _listenToStatsUpdates();
    // Optionally fetch location on initialization
    // getUserLocation();
  }

  final FirebaseFirestore _firebaseService = FirebaseFirestore.instance;

  // ────────────────────────────────────────────────
  // INTERNAL LOADERS
  // ────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ────────────────────────────────────────────────
  // LOCATION METHODS
  // ────────────────────────────────────────────────

  /// Check if location services are enabled
  Future<bool> _checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setError('Location services are disabled. Please enable them.');
      return false;
    }
    return true;
  }

  /// Check and request location permissions
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setError('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setError(
        'Location permissions are permanently denied. Please enable them from settings.',
      );
      return false;
    }

    return true;
  }

  /// Get current position
  Future<Position?> _getCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print('Error getting position: $e');
      _setError('Failed to get current location');
      return null;
    }
  }

  /// Get address from coordinates
  Future<Placemark?> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first;
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      _setError('Failed to get address from location');
      return null;
    }
  }

  /// Main method to get user location and district
  Future<void> getUserLocation() async {
    try {
      _isLoadingLocation = true;
      notifyListeners();
      clearError();

      // Check location services
      bool servicesEnabled = await _checkLocationServices();
      if (!servicesEnabled) {
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      // Check permissions
      bool hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      // Get current position
      Position? position = await _getCurrentPosition();
      if (position == null) {
        _isLoadingLocation = false;
        notifyListeners();
        return;
      }

      _currentPosition = position;

      // Get address details
      Placemark? placemark = await _getAddressFromCoordinates(position);
      if (placemark != null) {
        _userDistrict = placemark.subAdministrativeArea ?? placemark.locality;
        _userCity = placemark.locality ?? placemark.subLocality;
        _userCountry = placemark.country;

        print('=== Location Details ===');
        print('District: $_userDistrict');
        print('City: $_userCity');
        print('Country: $_userCountry');
        print('Latitude: ${position.latitude}');
        print('Longitude: ${position.longitude}');
        print('========================');
      }

      _isLoadingLocation = false;
      notifyListeners();
    } catch (e, stacktrace) {
      print('Error in getUserLocation: $e');
      print(stacktrace);
      _setError('Failed to get location');
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  /// Get location string for display
  String getLocationString() {
    if (_userDistrict != null && _userCity != null) {
      return '$_userDistrict, $_userCity';
    } else if (_userDistrict != null) {
      return _userDistrict!;
    } else if (_userCity != null) {
      return _userCity!;
    }
    return 'Location not available';
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // ────────────────────────────────────────────────
  // LISTEN TO PROFILE UPDATES
  // ────────────────────────────────────────────────
  void _listenToProfileUpdates() {
    _homeRepository.userProfileStream().listen((data) {
      _profile = data;
      notifyListeners();
    });
  }

  // ────────────────────────────────────────────────
  // LISTEN TO STATS UPDATES
  // ────────────────────────────────────────────────
  void _listenToStatsUpdates() {
    _homeRepository.userStatsStream().listen((data) {
      _stats = data;
      notifyListeners();
    });
  }

  // ────────────────────────────────────────────────
  // FETCH PROFILE (One-time fetch)
  // ────────────────────────────────────────────────

  // In HomeRepository
  Stream<AppUser?> userFullStream() {
    final uid = _localStorageService.user["uid"];
    if (uid == null) return const Stream.empty();

    return _firebaseService.collection('users').doc(uid).snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return null;
      return AppUser.fromMap({
        'profile': data['profile'] as Map<String, dynamic>? ?? {},
        'stats': data['stats'] as Map<String, dynamic>? ?? {},
      });
    });
  }

  final CollectionReference _challengesRef =
      FirebaseFirestore.instance.collection('challenges');
  Stream<List<Challenge>> getAllChallenges() {
    return _challengesRef.orderBy('week').snapshots().map((snapshot) {
      final List<Challenge> challenges = snapshot.docs
          .map((doc) =>
              Challenge.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      return _fillMissingWeeks(challenges);
    });
  }

  // Fill weeks 1-35 with placeholders if not in Firestore
  List<Challenge> _fillMissingWeeks(List<Challenge> existing) {
    final Map<int, Challenge> map = {for (final c in existing) c.week: c};

    final List<Challenge> result = [];
    for (int w = 1; w <= 35; w++) {
      result.add(map[w] ?? _placeholder(w));
    }
    return result;
  }

  Challenge _placeholder(int week) {
    return Challenge(
      id: week.toString(),
      week: week,
      title: 'Week $week',
      description: 'Challenge not published yet',
      points: 0,
      badgeUrl: '',
      level: 1,
      tasks: List.generate(
          7, (i) => DailyTask(day: i + 1, task: '', completed: false)),
    );
  }

  int selectedWeek = 0;
  changeSelectedWeek(int index) {
    selectedWeek = index;
    notifyListeners();
  }

  CollectionReference get _submittedPost =>
      _firebaseService.collection('submit');
  
  postSubmit(File image, int index) async {
    try {
      // 1. Upload image to ImgBB
      final uploadedImageUrl = await ImgBBService.uploadImage(image);

      // 2. Get current user UID
      final uid = _localStorageService.user["uid"];
      if (uid == null) throw Exception("User not logged in");

      // 3. Fetch user document
      final userDocRef = _firebaseService.collection('users').doc(uid);
      final userSnapshot = await userDocRef.get();

      if (!userSnapshot.exists) {
        throw Exception("User document not found in Firestore!");
      }

      final userData = userSnapshot.data()!; // Map<String, dynamic>

      // Print user data nicely
      final profile = userData['profile'] as Map<String, dynamic>? ?? {};

      // Get the user name correctly
      final userName = profile['displayName'] ??
          profile['username'] ??
          profile['email']?.split('@')[0] ??
          'Unknown User';

      // Nested stats
      final stats = userData['stats'] as Map<String, dynamic>?;
      final level = stats?['level'] ?? 0;

      // Get location if available
      String? location;
      if (_userDistrict != null) {
        location = getLocationString();
      }

      // 4. Save submission
      final submissionData = {
        'uid': uid,
        'userName': userName,
        'week': selectedWeek + 1,
        'day': index + 1,
        'imageUrl': uploadedImageUrl,
        'isApproved': "pending",
        'submittedAt': FieldValue.serverTimestamp(),
        if (location != null) 'location': location,
        if (_currentPosition != null) 'coordinates': {
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
        },
      };

      print("=== Submission Data ===");
      submissionData.forEach((key, value) {
        print("$key : $value");
      });
      print("=======================");

      await _firebaseService.collection('submit').doc(uid).set(
            submissionData,
            SetOptions(merge: true),
          );

      print("Submission successful!");
    } catch (e, stacktrace) {
      print("Error in postSubmit: $e");
      print(stacktrace);
      rethrow;
    }
  }

  // ────────────────────────────────────────────────
  // FETCH STATS (One-time fetch)
  // ────────────────────────────────────────────────
  Future<void> loadUserStats() async {
    try {
      _setLoading(true);
      clearError();

      _stats = await _homeRepository.getUserStats();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load stats');
    } finally {
      _setLoading(false);
    }
  }

  // ────────────────────────────────────────────────
  // SIGN OUT
  // ────────────────────────────────────────────────
  Future<void> signOut() async {
    try {
      _setLoading(true);
      clearError();
      await _homeRepository.signOut();
    } catch (e) {
      _setError("Failed to sign out");
    } finally {
      _setLoading(false);
    }
  }
}