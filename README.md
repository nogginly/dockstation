# Dockstation

Run `docker` on macOS for local development. This project was inspired by this[^1] article.

**Contents**
- [At the very least :-)](#at-the-very-least--)
- [Get started using `ops`](#get-started-using-ops)
  - [Additions `ops` commands](#additions-ops-commands)
  - [Multiple Dockstations](#multiple-dockstations)
- [Configuration](#configuration)
  - [Port Forwarding](#port-forwarding)
- [Get started manually](#get-started-manually)
  - [Dependencies](#dependencies)
  - [Deploy](#deploy)
  - [Verify](#verify)
- [Under the hood](#under-the-hood)
- [Contribution Policy](#contribution-policy)
- [References](#references)

## At the very least :-)

You need [Homebrew](https://brew.sh).

## Get started using `ops`

If you have [`ops`](https://github.com/nickthecook/ops) [^2] then all you have to do is the following after you clone this repo.

```sh
ops up
source tmp/local-setup.sh
```

And you're ready to go with the defaults.  Run `docker ps` to verify.

> If you don't use [`ops`](https://github.com/nickthecook/ops), I recommend you give it a go. Otherwise, follow the manual steps below.

### Additions `ops` commands

| Command       | Description                                                                                                   |
| ------------- | ------------------------------------------------------------------------------------------------------------- |
| `ops start`   | Start/resume the Dockstation VM                                                                               |
| `ops stop`    | Suspend the VM by saving it's state before shutting the VM down.                                              |
| `ops destroy` | Destroy the Dockstation, deletes all the containers and images within. You can always `ops start`  a new one. |
| `ops restart` | Use this to restart the VM with updates to port forwarding configuration.                                     |

### Multiple Dockstations

`ops` supports multiples "environments" where you can configure each and then switch between them by using the `$environment` variable. This is typically used for switching between `dev` and `staging` and `production` environments; similarly, here, we can use it to run multiple and separate Dockstations to separate containers run for those environments.

> More about multiple Dockstations coming soon.

## Configuration

The following environment variables can be used before deploying the VM to change the default configuration:

| Variable              | Default Value      | Description                                       |
| --------------------- | ------------------ | ------------------------------------------------- |
| `OPT_DOCKER_PORT`     | `2375`             | The guest docker port and the forwarded host port |
| `OPT_VM_IP`           | `192.168.56.81`    | The VM's host-accessible IP address               |
| `OPT_VM_MEM_MB`       | `2048`             | The amount of memory allocated to the VM          |
| `OPT_VM_HOSTNAME`     | `dockstation`      | The VM's host name                                |
| `OPT_VM_LOCALNAME`    | `$OPT_VM_HOSTNAME` | The VM's local name that vagrant lists.           |
| `OPT_VM_PORT_FORWARD` | `[]`               | See port forwarding section below for details.    |

### Port Forwarding

To reach a container's application port from your host via `localhost`, you need to specify which "host" ports to forward to which "vm" ports. You can do this via the `OPT_VM_PORT_FORWARD` env variable.

The variable takes a string with a JSON array of records. Here's an example:

```sh
OPT_VM_PORT_FORWARD=[{"host":5432,"vm":5432,"name":"postgres"},{"both":6379,name:"redis"}]
```

Each rule record has to be defined as follows:

| Property | Type of value | Description                                                           |
| -------- | ------------- | --------------------------------------------------------------------- |
| `host`   | Number        | The port number on the host running the VM                            |
| `vm`     | Number        | The port number on the VM (otherwise known as "guest")                |
| `both`   | Number        | If both host and vm ports are the same, use this to specify one value |
| `name`   | String        | A name of the service/app.                                            |

> If you're using `ops` then you can specify this in your `config/$environment/config.json` file as a JSON value and the encoding will just happen.

## Get started manually

### Dependencies

```sh
brew install virtualbox
brew install vagrant
brew install docker
brew install docker-compose
```

### Deploy

```sh
vagrant up
source tmp/local-setup.sh
```

The local config sets up `DOCKER_HOST` to point to the pre-configured IP and PORT for the VM and docker daemon running in it, respectively.

### Verify

Try running `docker ps` and you should see the following:

```
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
## Under the hood

The `Vagrantfile` uses the `bento/ubuntu-20.04` box via the Vagrant cloud public box repository.

## Contribution Policy

Dockstation is open to code contributions for bug fixes only. Features carry a long-term maintenance burden so they will not be accepted at this time. Please submit an issue if you have a feature you'd like to request.

## References

[^1]: [Run Docker without Docker Desktop](https://dhwaneetbhatt.com/blog/run-docker-without-docker-desktop-on-macos) article.

[^2]: [ops](https://github.com/nickthecook/ops) is like an operations team for your project. It allows you to implement automation for your project in a simple and readable way.

