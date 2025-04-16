#!/bin/bash

# Create folders
mkdir -p lib/{core,models,services,providers,views/{auth,home,books,swaps,profile},widgets,utils}

# Create files
touch lib/app.dart
touch lib/core/constants.dart
touch lib/core/theme.dart
touch lib/models/user_model.dart
touch lib/models/book_model.dart
touch lib/models/swap_model.dart
touch lib/services/auth_service.dart
touch lib/services/firestore_service.dart
touch lib/services/storage_service.dart
touch lib/services/notification_service.dart
touch lib/providers/auth_provider.dart
touch lib/providers/book_provider.dart
touch lib/providers/swap_provider.dart
touch lib/views/auth/login_screen.dart
touch lib/views/auth/signup_screen.dart
touch lib/views/home/home_screen.dart
touch lib/views/books/add_book_screen.dart
touch lib/views/books/book_detail_screen.dart
touch lib/views/swaps/swap_request_screen.dart
touch lib/views/profile/profile_screen.dart
touch lib/widgets/custom_button.dart
touch lib/widgets/book_card.dart
touch lib/widgets/profile_avatar.dart
touch lib/utils/validators.dart
touch lib/utils/extensions.dart
