import 'package:flutter/material.dart';

class _Tool {
  const _Tool(this.title, this.description, this.icon);
  final String title;
  final String description;
  final IconData icon;
}

const _tools = <_Tool>[
  _Tool(
    'Network & Connectivity',
    'IP, DNS, HTTP, TLS and network tests',
    Icons.lan_outlined,
  ),
  _Tool(
    'System & Device',
    'Device information and sensor overview',
    Icons.devices_outlined,
  ),
  _Tool(
    'Developer Tools',
    'JSON, encoders, hashes and text utilities',
    Icons.code,
  ),
  _Tool(
    'Server Administration',
    'SSH, Docker, monitoring and APIs',
    Icons.dns_outlined,
  ),
  _Tool(
    'Engineering & Electronics',
    'Electrical and electronics helpers',
    Icons.electrical_services_outlined,
  ),
  _Tool(
    '3D Printing',
    'Filament, cost and G-code inspection',
    Icons.view_in_ar_outlined,
  ),
  _Tool(
    'Automation & Workflow',
    'Build and manage repeatable workflows',
    Icons.account_tree_outlined,
  ),
  _Tool(
    'Security & Privacy',
    'Secrets, hashes and certificate checks',
    Icons.shield_outlined,
  ),
  _Tool(
    'Files & Documents',
    'Inspect, compare and organize files',
    Icons.folder_outlined,
  ),
  _Tool(
    'Productivity',
    'Notes, tasks, timers and workspaces',
    Icons.check_circle_outline,
  ),
  _Tool(
    'Barcode & Scanner',
    'Scan and generate QR codes/barcodes',
    Icons.qr_code_scanner,
  ),
  _Tool(
    'Diagnostics & Troubleshooting',
    'Guided checks and diagnostic reports',
    Icons.troubleshoot,
  ),
];

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1100
        ? 3
        : width >= 650
            ? 2
            : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Tools'),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your toolbox',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'One app. Every tool.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.builder(
                  itemCount: _tools.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 124,
                  ),
                  itemBuilder: (context, index) {
                    final tool = _tools[index];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                child: Icon(
                                  tool.icon,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tool.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tool.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
