# Wikidata Consumer

## Overview

The Wikidata Consumer project is a sophisticated application designed to consume and process events from a Kafka stream, focusing primarily on historical battle events. It parses the events, processes them, and optionally stores them in a PostgreSQL database for further analysis or display. The project is structured into a main application and a library component, facilitating easy extension and integration with other systems.

## Features

- **Kafka Event Consumption:** Connects to Kafka topics to consume messages in real-time.
- **Event Processing:** Parses and processes JSON-formatted battle event messages.
- **Modular Design:** Separates core functionality into a reusable library.
- **CLI Support:** Configurable via command-line arguments for flexible deployment.
- **Instrumentation:** Built-in support for coverage analysis with `bisect_ppx`.

## Project Structure

- `bin/`: Contains the executable definitions and entry points.
- `lib/`: Houses the core library components, including event processing, Kafka consumption, and utility modules.

### Key Components

- `main.ml`: The main entry point for the application, setting up CLI arguments and launching the Kafka consumer.
- `Event_processor.ml`: Processes consumed Kafka messages, parsing them into structured events.
- `Postgres_connector.ml`: (Stub) Placeholder for PostgreSQL integration.
- `Kafka_consumer.ml`: Manages Kafka connection, message consumption, and processing flow.
- `Battle_event.ml`: Defines the data model for battle events and functions for parsing JSON messages.
- `Config.ml`: Contains the configuration model for the application.
- `Cli.ml`: Builds the CLI interface for the application.

## Getting Started

### Dependencies
- OCaml
- Dune
- Bisect_ppx (for coverage)
- Cmdliner (for CLI parsing)
- Lwt and Kafka_lwt (for asynchronous operations and Kafka integration)
- Yojson (for JSON parsing)

### Building the Project

To build the project, ensure you have Dune and OCaml installed, then run:

```
make
```

### Running the Application

The application can be run directly using Dune:

```
dune exec -- wikidata-consumer --kafka-brokers=<brokers> --kafka-topic=<topic> --postgres-conn-string=<conn_string> --sleep-interval=<interval>
```

Replace `<brokers>`, `<topic>`, `<conn_string>`, and `<interval>` with your Kafka brokers, topic, PostgreSQL connection string, and sleep interval, respectively.

## Development
### Adding New Features

- To add new event types or processors, extend `Battle_event.ml` and `Event_processor.ml`.
- For additional Kafka topics or different message formats, modify `Kafka_consumer.ml`.

### Testing

Run tests with

```
make test
```

This also generates code coverage.

## Contributing

Contributions are welcome! Please open issues for bugs or feature requests and submit pull requests for improvements.

## License
This project is licensed under [MIT License](LICENSE). Feel free to use, modify, and distribute according to the license terms.
