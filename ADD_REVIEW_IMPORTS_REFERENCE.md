# Add Review API - Import Reference

Quick reference for all imports used in the implementation.

---

## 📦 Request Model
```dart
// File: lib/data/api/request/add_review_request.dart
import 'package:json_annotation/json_annotation.dart';

part 'add_review_request.g.dart';
```

**Usage**:
```dart
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
```

---

## 🔌 Data Source (Interface & Implementation)

### Datasource Interface
```dart
// File: lib/data/datasource/review/review_datasource.dart
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/api/response/review_response.dart';
```

### Datasource Implementation
```dart
// File: lib/data/datasource/review/review_datasource_impl.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/data/api/api_client/api_client_type.dart';
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/api/response/error_response.dart';
import 'package:recovery_consultation_app/data/api/response/review_response.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource.dart';
```

**Usage**:
```dart
import 'package:recovery_consultation_app/data/datasource/review/review_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource_impl.dart';
```

---

## 📚 Repository (Interface & Implementation)

### Repository Interface
```dart
// File: lib/domain/repositories/review_repository.dart
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
```

### Repository Implementation
```dart
// File: lib/data/repository/review_repository_impl.dart
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource.dart';
import 'package:recovery_consultation_app/data/mapper/review_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import 'package:recovery_consultation_app/domain/entity/error_entity.dart';
import 'package:recovery_consultation_app/data/api/response/error_response.dart';
import 'package:recovery_consultation_app/data/mapper/exception_mapper.dart';
```

**Usage**:
```dart
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import 'package:recovery_consultation_app/data/repository/review_repository_impl.dart';
```

---

## 🎯 Use Case

```dart
// File: lib/domain/usecase/add_review_use_case.dart
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';
```

**Usage**:
```dart
import 'package:recovery_consultation_app/domain/usecase/add_review_use_case.dart';
```

---

## 🔧 DI Modules

### Datasource Module
```dart
// File: lib/di/datasource_module.dart
import 'package:recovery_consultation_app/data/datasource/review/review_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/review/review_datasource_impl.dart';
```

### Repository Module
```dart
// File: lib/di/repository_module.dart
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import 'package:recovery_consultation_app/data/repository/review_repository_impl.dart';
```

### Use Case Module
```dart
// File: lib/di/usecase_module.dart
import 'package:recovery_consultation_app/domain/usecase/add_review_use_case.dart';
```

---

## 🎮 Controller

### Patient Home Controller
```dart
// File: lib/presentation/patient_home/patient_home_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import '../../app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import '../../app/controllers/base_controller.dart';
import '../../domain/usecase/add_review_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/get_paginated_doctors_list_use_case.dart';
import '../../domain/usecase/get_paginated_appointments_list_use_case.dart';
import '../../domain/entity/appointment_entity.dart';
import '../../domain/entity/paginated_appointments_list_entity.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/string_extensions.dart';
import '../widgets/banner/sliding_banner.dart';
import '../widgets/rating_bottom_sheet.dart';
import '../navigation/nav_controller.dart';
import 'package:intl/intl.dart';
```

---

## 🧩 API Client

### APIClientType
```dart
// File: lib/data/api/api_client/api_client_type.dart

// Added imports:
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/data/api/response/review_response.dart';

// Existing imports (already there):
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import '../response/base_response.dart';
```

**Endpoint added**:
```dart
@retrofit.POST('/api/add-reviews')
Future<BaseResponse<ReviewResponse>> addReview(
  @retrofit.Body() AddReviewRequest request,
);
```

---

## ✅ Existing Models (No Changes Needed)

These models already exist in your codebase:

```dart
// ReviewResponse - already exists
import 'package:recovery_consultation_app/data/api/response/review_response.dart';

// DoctorReviewEntity - already exists
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';

// ReviewMapper - already exists
import 'package:recovery_consultation_app/data/mapper/review_mapper.dart';

// AppointmentEntity - already exists
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';

// Error handling utilities - already exist
import 'package:recovery_consultation_app/domain/entity/error_entity.dart';
import 'package:recovery_consultation_app/data/api/response/error_response.dart';
import 'package:recovery_consultation_app/data/mapper/exception_mapper.dart';
```

---

## 📊 Import Tree

```
APIClientType
├── AddReviewRequest
└── ReviewResponse
    └── ReviewMapper
        └── DoctorReviewEntity

ReviewDatasource
├── APIClientType
└── ReviewResponse

ReviewRepository
├── ReviewDatasource
├── ReviewResponse
├── ReviewMapper
└── DoctorReviewEntity

AddReviewUseCase
└── ReviewRepository

PatientHomeController
├── AddReviewUseCase
├── AddReviewRequest
└── DoctorReviewEntity

DI Modules
├── Datasource Module → ReviewDatasource
├── Repository Module → ReviewRepository
└── Use Case Module → AddReviewUseCase
```

---

## 🔍 Quick Lookup

**To submit a review**:
```dart
import 'package:recovery_consultation_app/domain/usecase/add_review_use_case.dart';
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
```

**To handle responses**:
```dart
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
```

**For error handling**:
```dart
import 'package:recovery_consultation_app/domain/entity/error_entity.dart';
```

**For API calls**:
```dart
import 'package:recovery_consultation_app/data/api/api_client/api_client_type.dart';
```

---

## 🏗️ Clean Imports (For Code Org)

**In a new controller that needs reviews**:
```dart
// Domain layer (use cases, entities)
import 'package:recovery_consultation_app/domain/usecase/add_review_use_case.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';

// Data layer (requests for API)
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';

// App controllers
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
```

---

## 🧪 Testing Imports

```dart
// For unit testing the use case
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recovery_consultation_app/domain/usecase/add_review_use_case.dart';
import 'package:recovery_consultation_app/domain/repositories/review_repository.dart';
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
```

---

## 📝 Reference

**Total new files**: 6
**Total modified files**: 7
**Total new imports**: ~30 distributed across files
**Build output**: 25 outputs, 259 actions (successful)

All files compile successfully! ✅
