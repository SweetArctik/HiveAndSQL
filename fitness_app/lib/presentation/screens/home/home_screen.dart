import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final todayStatsAsync = ref.watch(todayStatsProvider);
    final userPrefsAsync = ref.watch(userPreferencesProvider);
    final activeSessionAsync = ref.watch(activeSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
          ref.invalidate(todayStatsProvider);
          ref.invalidate(userPreferencesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Welcome Card
              currentUserAsync.when(
                data: (user) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, ${user?.nombre ?? 'Usuario'}!',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '¿Listo para entrenar hoy?',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cargando...'),
                              SizedBox(height: 4),
                              Text('Preparando tu perfil'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                error: (error, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $error'),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Today's Stats
              Text(
                'Estadísticas de Hoy',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              
              todayStatsAsync.when(
                data: (stats) => Row(
                  children: [
                    Expanded(
                      child: _StatsCard(
                        title: 'Entrenamientos',
                        value: '${stats['workouts_completed']}',
                        icon: Icons.fitness_center,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatsCard(
                        title: 'Calorías',
                        value: '${stats['calories_burned']}',
                        icon: Icons.local_fire_department,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatsCard(
                        title: 'Minutos',
                        value: '${stats['minutes_exercised']}',
                        icon: Icons.timer,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                loading: () => const Row(
                  children: [
                    Expanded(child: Card(child: SizedBox(height: 80))),
                    SizedBox(width: 8),
                    Expanded(child: Card(child: SizedBox(height: 80))),
                    SizedBox(width: 8),
                    Expanded(child: Card(child: SizedBox(height: 80))),
                  ],
                ),
                error: (error, _) => Text('Error cargando estadísticas: $error'),
              ),

              const SizedBox(height: 20),

              // Active Session Status
              activeSessionAsync.when(
                data: (session) => session != null
                    ? Card(
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.play_circle_filled, color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Entrenamiento en Progreso',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('${session.ejercicios.length} ejercicios planificados'),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: Navigate to active workout screen
                                  },
                                  child: const Text('Continuar Entrenamiento'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (error, _) => const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              // Quick Actions
              Text(
                'Acciones Rápidas',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () async {
                          // Create new workout session
                          final notifier = ref.read(activeSessionProvider.notifier);
                          await notifier.createSession();
                          // TODO: Navigate to workout screen
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.add_circle_outline, size: 32, color: Colors.green),
                              SizedBox(height: 8),
                              Text('Nuevo\nEntrenamiento', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigate to history screen
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.history, size: 32, color: Colors.blue),
                              SizedBox(height: 8),
                              Text('Ver\nHistorial', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          // TODO: Navigate to progress screen
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(Icons.trending_up, size: 32, color: Colors.purple),
                              SizedBox(height: 8),
                              Text('Ver\nProgreso', textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // User Preferences
              userPrefsAsync.when(
                data: (prefs) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tus Objetivos',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _ObjectiveRow(
                          icon: Icons.local_fire_department,
                          label: 'Calorías diarias',
                          value: '${prefs.objetivoCalorias}',
                          color: Colors.red,
                        ),
                        _ObjectiveRow(
                          icon: Icons.directions_walk,
                          label: 'Pasos diarios',
                          value: '${prefs.objetivoPasos}',
                          color: Colors.blue,
                        ),
                        _ObjectiveRow(
                          icon: Icons.fitness_center,
                          label: 'Entrenamientos por semana',
                          value: '${prefs.objetivoEntrenamientosSemana}',
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Cargando objetivos...'),
                  ),
                ),
                error: (error, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error cargando objetivos: $error'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final notifier = ref.read(activeSessionProvider.notifier);
          await notifier.createSession();
          // TODO: Navigate to workout screen
        },
        tooltip: 'Nuevo Entrenamiento',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ObjectiveRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ObjectiveRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}