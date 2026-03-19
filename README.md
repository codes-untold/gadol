# Product Catalog Flutter App

A modern Flutter application that displays a product catalog using a custom design system, consumes data from the DummyJSON REST API, and implements responsive layouts for different screen sizes.

## Table of Contents

- [Setup & Run Instructions](#setup--run-instructions)
- [Architecture Overview](#architecture-overview)
- [Design System Rationale](#design-system-rationale)
- [Features](#features)
- [Limitations & Future Improvements](#limitations--future-improvements)
- [AI Tools Usage](#ai-tools-usage)

---

## Setup & Run Instructions

### Prerequisites

- **Flutter**: ^3.8.1 (or later)
- **Dart**: ^3.8.1 (included with Flutter)
- **macOS/Linux/Windows** development environment
- **iOS 11.0+** or **Android 21+** (depending on platform)

### Installation

1. **Clone the repository**
   ```bash
   cd gadol
   git clone <repository-url> .
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**

   **Development**:
   ```bash
   flutter run
   ```

   **Release** (iOS):
   ```bash
   flutter run --release -t lib/main.dart
   ```

   **Release** (Android):
   ```bash
   flutter run --release -t lib/main.dart
   ```

4. **Run tests**

   **All tests**:
   ```bash
   flutter test
   ```

   **Specific test file**:
   ```bash
   flutter test test/models/product_test.dart
   ```

   **Tests with coverage**:
   ```bash
   flutter test --coverage
   ```

### Project Structure

```
lib/
├── core/
│   ├── design_system/           # Reusable UI components
│   │   ├── category_chip.dart   # Category filter chip component
│   │   ├── design_tokens.dart   # Design system tokens (spacing, radius, shadows)
│   │   ├── product_card.dart    # Product list item component
│   │   ├── search_bar.dart      # Search input component
│   │   └── states.dart          # Error, Empty, Loading state components
│   └── theme/
│       └── app_theme.dart       # Light/dark theme configuration
├── data/
│   ├── models/
│   │   └── product.dart         # Product and ProductResponse models
│   └── repositories/
│       └── product_repository.dart  # API communication layer
├── presentation/
│   ├── bloc/
│   │   ├── categories_cubit.dart        # Categories state management
│   │   ├── product_detail_cubit.dart    # Product detail state management
│   │   └── products_bloc.dart           # Products list state management
│   ├── router/
│   │   └── app_router.dart      # Route configuration with GoRouter
│   └── screens/
│       ├── product_detail_screen.dart   # Product details view
│       ├── product_list_screen.dart     # Product list with search/filter
│       └── responsive_layout_screen.dart # Tablet master-detail layout
└── main.dart                    # App entry point

test/
├── bloc/                        # Bloc/Cubit tests
├── mocks/                       # Mock objects and repositories
├── models/                      # Model/serialization tests
└── widgets/                     # Widget component tests
```

---

## Architecture Overview

### Design Principles

This app follows **clean architecture** principles with clear separation of concerns:

1. **Data Layer** (`data/`)
   - Models for type-safe data handling
   - Repository pattern for API communication
   - Graceful error handling and data validation

2. **Domain/Business Logic** (`presentation/bloc/`)
   - Bloc/Cubit for state management
   - Events for user actions
   - States for UI synchronization

3. **Presentation Layer** (`presentation/screens/`, `core/design_system/`)
   - Reusable design system components
   - Screen widgets that consume state
   - Responsive layout handling

### State Management: Bloc/Cubit

We use **Flutter Bloc** for state management because it:
- Provides predictable state transitions
- Enables easy testing of business logic
- Scales well for complex apps
- Has strong community support

**State Management Structure:**

```
ProductsBloc (Events-based):
├── FetchProductsEvent → triggers initial product load with filters
├── LoadMoreProductsEvent → pagination trigger
├── UpdateCategoryFilterEvent → category filtering
└── UpdateSearchQueryEvent → search query updates

CategoriesCubit (Simple state):
└── fetchCategories() → loads product categories

ProductDetailCubit (Simple state):
└── fetchProductDetail(id) → loads single product details
```

### Routing: GoRouter

We use **GoRouter** for declarative routing with these advantages:
- Type-safe URL parameters
- Deep linking support (e.g., `/products/:id`)
- Built-in navigation history
- Responsive routing based on screen size

**Routing Logic:**
- **Phone** (< 768px): Standard push navigation between screens
- **Tablet** (≥ 768px): Master-detail layout with adaptive routing

### API Integration

The `ProductRepository` handles all API communication:
- **Base URL**: `https://dummyjson.com`
- **Key Features**:
  - Pagination with limit/skip parameters
  - Server-side search
  - Category filtering
  - Individual product details
  - Built-in logging and error handling

---

## Design System Rationale

### Component Library

We created a cohesive design system to ensure consistency and reusability:

1. **ProductCard**
   - Displays product with image, title, brand, price, rating, and discount
   - Skeleton loader for loading states
   - Responsive image handling with fallback

2. **SearchBar**
   - Text input with search icon
   - Clear button functionality
   - Debouncing support (handled at Bloc level)

3. **CategoryChip**
   - Toggle-able filter chip
   - Selected/unselected visual states
   - Horizontal scrollable layout

4. **State Components**
   - `ErrorState`: Error display with retry button
   - `EmptyState`: Empty results display
   - `LoadingIndicator`: Centered circular progress

### Theme Implementation

**Design Tokens** (`design_tokens.dart`):
- Padding: xs (4px), sm (8px), md (16px), lg (24px), xl (32px)
- Radius: sm (4px), md (8px), lg (12px), xl (16px)
- Typography scale with consistent line heights
- Shadow elevations (small, medium, large)

**Color System** (`app_theme.dart`):
- Material Design 3 compliant
- Light theme: Purple primary (#6200EA)
- Dark theme: Lavender primary (#D0BCFF)
- Comprehensive color palette for all states

### Why This Design System?

- **Consistency**: All components follow the same design language
- **Maintainability**: Changes propagate across the app
- **Accessibility**: Proper contrast ratios and text sizing
- **Performance**: Const constructors and efficient rendering
- **Theming**: Full support for light and dark modes

---

## Features

### Product List Screen
✅ Infinite scroll with pagination
✅ Search products by name (debounced)
✅ Filter by category
✅ Combined search + category filtering
✅ Loading states with shimmer placeholders
✅ Error states with retry functionality
✅ Empty states for no results

### Product Detail Screen
✅ Full product information display
✅ Horizontally scrollable image gallery
✅ Image indicators (current page dots)
✅ Product metadata (brand, category, ratings)
✅ Price display with discount calculation
✅ Stock availability indicator
✅ "Add to Cart" action

### Responsive Design
✅ Phone layout: Standard push navigation
✅ Tablet layout (≥ 768px): Master-detail side-by-side
✅ Adaptive AppBar and spacing
✅ Deep linking: `/products/:id` URL support

### Data Handling
✅ Graceful error handling for invalid data
✅ Placeholder images for missing URLs
✅ Sensible defaults for missing fields
✅ Price validation and fallback display
✅ Image lazy loading and caching

---

## Limitations & Future Improvements

### Current Limitations

1. **Search Debouncing**
   - Currently implemented at UI level without explicit debounce duration
   - Could be improved with more aggressive debouncing (500ms+)

2. **Image Caching**
   - Using cached_network_image with default settings
   - No custom cache size configuration
   - Could implement persistent disk cache

3. **State Persistence**
   - Scroll position not preserved on back navigation
   - No local caching of API responses
   - Could use HiveDB or SharedPreferences

4. **Pagination UX**
   - Simple "load more at bottom" approach
   - No explicit "Load More" button
   - Could add pagination controls

5. **Performance**
   - No virtual scrolling optimization
   - All 100+ products rendered in memory
   - Could implement AutomaticKeepAliveClientMixin

6. **Accessibility**
   - No screen reader optimization
   - Limited keyboard navigation
   - Could improve semantic labeling

### Future Improvements

1. **Shopping Cart**
   - Persistent cart with local storage
   - Cart persistence across sessions
   - Checkout flow

2. **User Preferences**
   - Save favorite products
   - Recently viewed history
   - Personalized recommendations

3. **Advanced Filtering**
   - Price range slider
   - Rating filter
   - Stock availability filter
   - Multi-select categories

4. **Performance**
   - Virtual scrolling for large lists
   - Image blur-up effect
   - Placeholder with average color

5. **Offline Support**
   - Cache API responses locally
   - Serve cached data when offline
   - Sync when back online

6. **Analytics**
   - Track product views
   - Search query analytics
   - User behavior tracking

7. **Additional Features**
   - Product reviews and ratings
   - Related products section
   - Share product via social media
   - Compare products side-by-side

---

## AI Tools Usage

### How AI Was Used

GitHub Copilot and Claude were used throughout this project to:

1. **Component Development**
   - Generated boilerplate for design system components
   - Implemented ProductCard with image handling
   - Created CategoryChip with state management
   - Suggestion for error/empty states

2. **State Management**
   - Bloc event/state structure generation
   - Error handling patterns
   - Cubit lifecycle hooks
   - Refactoring for better separation of concerns

3. **API Integration**
   - HTTP client setup and configuration
   - Error handling and retry logic
   - JSON parsing with validation
   - Logging and debugging helpers

4. **Testing**
   - Unit test setup and patterns
   - Mock object generation
   - BlocTest usage patterns
   - Widget test assertions

5. **Documentation**
   - README structure and content
   - Code comments and docstrings
   - Architecture explanation
   - Troubleshooting guides

### What Was Changed/Refined

1. **Component Refinement**
   - Added custom skeleton loader for ProductCard
   - Enhanced image error handling with actual placeholder URLs
   - Improved chip styling for better visual hierarchy

2. **State Management Optimization**
   - Separated search and category logic initially suggested as one event
   - Added explicit pagination state tracking
   - Improved error propagation

3. **Data Validation**
   - Enhanced Product.fromJson() with sensible defaults
   - Added explicit null/empty checks
   - Custom placeholder URL generation for missing images

4. **Testing Approach**
   - Organized tests by feature (bloc, models, widgets)
   - Added comprehensive edge case tests
   - Mock repository for dependency isolation

5. **Architecture Decisions**
   - Used Bloc instead of Riverpod for consistency
   - Implemented custom design tokens instead of Material 3 defaults
   - Separate Cubit for categories instead of combining with products

### AI Limitations Addressed

1. **Code Quality**
   - Reviewed AI-generated code for performance issues
   - Added const constructors where applicable
   - Optimized widget rebuilds

2. **Error Handling**
   - Enhanced generic error handling with specific messages
   - Added proper exception propagation
   - Implemented user-friendly error displays

3. **Design Consistency**
   - Ensured all components follow the custom design system
   - Maintained consistent spacing and typography
   - Verified color scheme implementation

---

## Testing

### Test Coverage

```
Unit Tests:
├── Product Model (11 tests)
│   ├── JSON parsing with valid data
│   ├── Default values for missing fields
│   ├── Placeholder image generation
│   ├── Negative price handling
│   └── ProductResponse parsing
├── ProductsBloc (6 tests)
│   ├── Initial fetch and loading
│   ├── Empty and error states
│   ├── Pagination/load more
│   ├── Search functionality
│   └── Category filtering
├── CategoriesCubit (2 tests)
│   ├── Categories load success
│   └── Categories load error
└── ProductDetailCubit (2 tests)
    ├── Detail fetch success
    └── Detail fetch error

Widget Tests:
├── ProductCard (8 tests)
│   ├── Title, brand, price display
│   ├── Discount badge visibility
│   ├── Rating display
│   ├── Loading skeleton
│   └── Tap interactions
└── CategoryChip (8 tests)
    ├── Label display
    ├── Selected/unselected states
    ├── Tap interactions
    └── Multiple chips layout
```

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/models/product_test.dart

# With coverage
flutter test --coverage
lcov --list coverage/lcov.info
```

---

## Troubleshooting

### Common Issues

**Issue**: `Flutter doctor` shows errors
```bash
# Solution
flutter doctor -v
flutter pub get
```

**Issue**: Tests fail with "mocktail not found"
```bash
# Solution
flutter pub get
flutter test
```

**Issue**: App crashes on product list load
```bash
# Solution
- Ensure internet connection
- Check API endpoint availability
- Review logs with: flutter logs
```

**Issue**: UI doesn't adapt to tablet layout
```bash
# Solution
- Restart app in landscape mode
- Check MediaQuery.of(context).size.width
- Ensure window width > 768px
```

---

## Performance Considerations

1. **Image Loading**
   - Using `cached_network_image` for automatic caching
   - Images loaded with `fit: BoxFit.cover`
   - Placeholder during load and error fallback

2. **List Performance**
   - Infinity scroll prevents loading all 1000+ products at once
   - 20 products per page manages memory footprint
   - Consider virtual scrolling for future versions

3. **State Management**
   - Bloc event processing is sequential
   - UI rebuilds only when state changes
   - Proper use of Equatable for state comparison

4. **Memory**
   - 20 products per page manageable memory footprint
   - Images automatically garbage collected
   - No global state retention issues

---

## License

This project is part of a Flutter recruitment assessment.

---

**Built with Flutter 3.8.1+ | Dart 3.8.1+**
