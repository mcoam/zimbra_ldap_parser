This script allow parser Zimbra ldap file and save to CSV format, for running the script is necesary obtain the ldap.back 

1. Extract ldap.bak

```bash
 su - zimbra -c "/opt/zimbra/libexec/zmslapcat /var/tmp"
```

2. Run perl script

```perl
perl parser.pl /var/tmp/ldap.bak
```

3. Output file `domain.csv`

```
CUENTA DE CORREO	NOMBRE DE USUARIO	ESTADO DE CASILLA	TIPO CASILLA	F. CREACION
mcanala@example.com	Miguel mcanala		Enabled			18-06-2018	Premium
srosas@example.com	Sebastian Rosas		Enabled			18-07-2018	Profesional
multipuerto@example.com	Multipuerto multipuerto	Enabled			19-07-2017	Basica
pescudero@example.com	Paulina Escudero	Enabled			23-12-2017	Profesional
```
