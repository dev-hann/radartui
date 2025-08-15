## 📁 lib/src/scheduler

This directory manages the lifecycle and frame scheduling of the RadarTUI application. It acts as the glue that connects the 'engine' and the 'framework'.

### Key Files

- **`binding.dart`**: Contains the `SchedulerBinding` singleton, which acts as the heart of the framework. It manages the app's main event loop, including receiving keyboard input, requesting frames (the build → layout → paint pipeline), and handling terminal resize signals.