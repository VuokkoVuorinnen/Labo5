# Labo-opdrachten Enterprise Linux

In deze repository vind je een basisopstelling voor het uitwerken van de labo-opdrachten van Enterprise Linux (3e Bach Toegepaste Informatica, @HogentFBO).

## Aan de slag

Om de opgave van labo 5 (DNS/DHCP) te downloaden, doe je het volgende:

```
#!bash

$ git clone https://bertvanvreckem@bitbucket.org/bertvanvreckem/elnx-labos.git
$ cd elnx-labos
$ git fetch && git checkout opgave-dns-dhcp

```

## Structuur repository

De Vagrantfile bevat 3 VM-definities:

- helium: een DNS-server
- beryllium: een DHCP-server
- neon: een test-client voor DHCP

De directory `hiera` bevat alle "variabelen" die ingevuld moeten worden in de manifests (bv. IP-adressen)

De directory `manifests/nodes/` bevat al een node-definitie voor `beryllium` en `helium`.

Voor het importeren van modules, zie de README in de `modules`-directory.

## Host-only network

Voor je de VMs opstart, moet je zorgen dat je in VirtualBox een Host-only netwerk hebt met de naam `vboxnet2` waar je host-systeem IP-adres 192.168.64.1 heeft. Onder Windows is de naamgeving anders. Pas daarom na het creëren van het Host-onlynetwerk de Vagrantfile aan.

## Test suite

De subdirectory `tests` bevat testscripts voor de VMs. Om de test suite voor een bepaalde host uit te voeren, log je in op de machine (met `vagrant ssh`) en voer je het script `/etc/puppet/tests/run_tests.sh` uit. Dat zal op zijn beurt de juiste test suite voor die host opzoeken en uitvoeren als die bestaat. Voor een host met de naam (meer bepaald FQDN) _helium.chem.net_, bijvoorbeeld staan de tests in `helium.chem.net.bats`.


