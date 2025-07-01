import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';

// Кастомная кнопка с анимацией нажатия и наведения
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final String label;

  const AnimatedIconButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _rotationAnim;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _rotationAnim = Tween<double>(begin: 0, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onEnter(PointerEvent _) {
    setState(() => _isHovered = true);
  }

  void _onExit(PointerEvent _) {
    setState(() => _isHovered = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _iconColor =>
      widget.isSelected ? widget.selectedColor : widget.unselectedColor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final scale = _isPressed ? _scaleAnim.value : (_isHovered ? 1.1 : 1.0);
            final rotation = _isPressed ? _rotationAnim.value : 0.0;
            return Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: _iconColor),
                    const SizedBox(height: 2),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: _iconColor,
                        fontSize: 12,
                        fontWeight:
                            widget.isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RickAndMortyApp extends StatefulWidget {
  const RickAndMortyApp({super.key});

  @override
  State<RickAndMortyApp> createState() => _RickAndMortyAppState();
}

class _RickAndMortyAppState extends State<RickAndMortyApp>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isDarkTheme = false;

  late AnimationController _themeIconController;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _toggleTheme() async {
    await _themeIconController.forward();
    setState(() => _isDarkTheme = !_isDarkTheme);
    await _themeIconController.reverse();
  }

  @override
  void initState() {
    super.initState();
    _themeIconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _themeIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [const HomeScreen(), const FavoritesScreen()];

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.green.shade50,
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent, brightness: Brightness.dark),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? darkTheme : lightTheme,
      home: Stack(
        children: [
          // Анимированный фон
          const AnimatedBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Rick and Morty'),
              elevation: 4,
              actions: [
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _themeIconController,
                      curve: Curves.easeInOutBack,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(_isDarkTheme ? Icons.wb_sunny : Icons.nights_stay),
                    tooltip: 'Сменить тему',
                    onPressed: _toggleTheme,
                  ),
                ),
              ],
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                final offsetAnimation =
                    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(animation);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              child: screens[_selectedIndex],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.green.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedIconButton(
                      icon: Icons.list,
                      isSelected: _selectedIndex == 0,
                      onTap: () => _onItemTapped(0),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      unselectedColor: Theme.of(context).disabledColor,
                      label: 'Персонажи',
                    ),
                    AnimatedIconButton(
                      icon: Icons.star,
                      isSelected: _selectedIndex == 1,
                      onTap: () => _onItemTapped(1),
                      selectedColor: Theme.of(context).colorScheme.primary,
                      unselectedColor: Theme.of(context).disabledColor,
                      label: 'Избранное',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat(reverse: true);

    _color1 = ColorTween(begin: Colors.deepPurple, end: Colors.tealAccent)
        .animate(_controller);
    _color2 = ColorTween(begin: Colors.black, end: Colors.deepPurpleAccent)
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_color1.value!, _color2.value!],
              ),
            ),
          );
        });
  }
}
