#import "../shared.typ": *

#num_head[
    Настройка оборудования
]

#body_text[
    Настройка оборудования - это важный этап в процессе внедрения и эксплуатации любой системы. Правильная настройка обеспечивает оптимальную работу устройств, их совместимость и безопасность, что в конечном итоге влияет на эффективность работы всей организации.

    В данном проекте настройке подлежат:
]

#dash_list[

    - Маршрутизатор MikroTik RB5009UG+S+IN;

    - Коммутаторы MikroTik CRS328-24P-4S+RM и CRS326-24G-2S+RM;

    - Точки доступа MikroTik cAPGi-5HaxD2HaxD;

    - Система видеонаблюдения Hikvision;

    - IP-телефония;

    - Рабочие станции сотрудников.
]

#num_sub_head[
    Настройка маршрутизатора
]

#body_text[
    Настроены: router-on-a-stick, dhcp, capsman, firewall, dns. Настройка оборудования имеет следующий вид:
]

#dash_list[

    - \# Создание пользователя
    - user set admin password=32FHE&lka;

    - interface bridge add name=bridge-vlan vlan-filtering=yes;

    - interface bridge port add bridge=bridge-vlan interface={на коммут центральный} frame-types=admit-only-vlan-tagged ingress-filtering=yes;
    - interface bridge port add bridge=bridge-vlan interface={на коммут справа} frame-types=admit-only-vlan-tagged ingress-filtering=yes;

    - interface vlan add name=vlan{10,20,90,100,200} vlan-id={10,20,90,100,200} interface=bridge-vlan;

    - ip address add address=192.168.{10, 20, 90, 100, 200}.1/24 interface=vlan{10, 20, 90, 100, 200};

    - interface bridge vlan add bridge=bridge-vlan vlan-ids=[10,20,90,100,200] tagged=bridge-vlan,[интерфейс на коммут];

    - ip pool add name=pool{10, 20, 90, 100, 200} ranges=192.168.{10, 20, 90, 100, 200}.10-192.168.{10, 20, 90, 100, 200}.254;

    - ip dhcp-server add name=dhcp{10, 20, 90, 100, 200} interface=vlan{10, 20, 90, 100, 200} address-pool=pool{10, 20, 90, 100, 200};

    - ip dhcp-server network add address=192.168.{10, 20, 90, 100, 200}.0/24 gateway=192.168.{10,20,90,100,200}.1 dns-server=192.168.{10, 20, 90, 100, 200}.1;

    - ip dns set allow-remote-requests=yes servers=1.1.1.1,8.8.8.8;

    - ip firewall nat add chain=srcnat out-interface={интерфейс провайдера} action=masquerade;

    - ip firewall filter add chain=input connection-state=established,related action=accept;

    - ip firewall filter add chain=input protocol=icmp action=accept;

    - ip firewall filter add chain=input in-interface=vlan200 action=accept;

    - ip firewall filter add chain=input action=drop;

    - ip firewall filter add chain=forward connection-state=established,related action=accept;

    - ip firewall filter add chain=forward src-address=192.168.90.0/24 dst-address=192.168.0.0/16 action=drop;

    - p firewall filter add chain=forward src-address=192.168.100.0/24 dst-address=192.168.10.0/24 action=drop;

    - ip firewall filter add chain=forward src-address=192.168.100.0/24 dst-address=192.168.20.0/24 action=drop;

    - ip firewall filter add chain=forward src-address=192.168.100.0/24 dst-address=192.168.90.0/24 action=drop;

    - ip firewall filter add chain=forward action=fasttrack-connection connection-state=established,related;

    - caps-man manager set enabled=yes;

    - caps-man security add name=sec-dev authentication-types=wpa2-psk,wpa3-psk encryption=aes-ccm passphrase=349nvDKFfj;

    - caps-man security add name=sec-business authentication-types=wpa2-psk,wpa3-psk encryption=aes-ccm passphrase=I23h9FMoh3;

    - caps-man security add name=sec-guest authentication-types=wpa2-psk encryption=aes-ccm passphrase=NVff2h3g4o;

    - caps-man datapath add name=dp-dev bridge=bridge-vlan vlan-id=10 vlan-mode=use-tag local-forwarding=yes;

    - caps-man datapath add name=dp-business bridge=bridge-vlan vlan-id=20 vlan-mode=use-tag local-forwarding=yes;

    - caps-man datapath add name=dp-guest bridge=bridge-vlan vlan-id=90 vlan-mode=use-tag local-forwarding=yes client-to-client-forwarding=no;

    - caps-man channel add name=ch-2ghz band=2ghz-ax frequency=2412,2437,2462 width=20mhz;

    - caps-man channel add name=ch-5ghz band=5ghz-ax frequency=5180,5260,5500,5580 width=20/40/80mhz;

    - caps-man configuration add name=cfg-dev ssid=Studio-Dev security=sec-dev datapath=dp-dev channel=ch-5ghz country=russia installation=indoor mode=ap;

    - caps-man configuration add name=cfg-business ssid=Studio-Business security=sec-business datapath=dp-business channel=ch-5ghz country=russia installation=indoor mode=ap;

    - caps-man configuration add name=cfg-guest ssid=Studio-Guests security=sec-guest datapath=dp-guest channel=ch-5ghz country=russia installation=indoor mode=ap;

    - aps-man provisioning add action=create-dynamic-enabled master-configuration=cfg-dev slave-configurations=cfg-business,cfg-guest;


]

#num_sub_head[
    Настройка коммутатора уровня распределения
]

#body_text[
    Настроены vlan, PoE, rstp. Настройка оборудования имеет следующий вид
]

#dash_list[
    - interface bridge add name=bridge-vlan vlan-filtering=yes protocol-mode=rstp;
    - interface bridge port add bridge=bridge-vlan interface={trunk-порты} frame-types=admit-only-vlan-tagged ingress-filtering=yes;
    - interface bridge port add bridge=bridge-vlan interface=камеры pvid=100 frame-types=admit-only-untagged-and-priority-tagged ingress-filtering=yes;

    - interface bridge vlan add bridge=bridge-vlan vlan-ids={перечисляем вланы, например, 1} tagged=bridge-vlan,{trunk порты через ,};
    
    - interface vlan add name=vlan200 interface=bridge-vlan vlan-id=200;
    - ip address add address=192.168.200.2/24 interface=vlan200;
    - ip route add gateway=192.168.200.1;
    
    - ip service set telnet disabled=yes;
    - ip service set ftp disabled=yes;
    - ip service set www disabled=yes;

    - ip firewall filter add chain=input connection-state=established,related action=accept;
    - ip firewall filter add chain=input in-interface=vlan200 action=accept;
    - ip firewall filter add chain=input action=drop;

    - interface bridge set bridge-vlan protocol-mode=rstp priority=0x1000;
    - interface bridge set bridge-vlan comment="ROOT BRIDGE CORE";
    
    - interface ethernet poe set {poe-порты} poe-out=forced-on;
]

#num_sub_head[
    Настройка коммутатора уровня доступа
]

#body_text[
    Настроены vlan, rstp. Настройка оборудования имеет следующий вид:
]

#dash_list[
    - interface bridge add name=bridge-vlan vlan-filtering=yes protocol-mode=rstp;
    
    - interface bridge port add bridge=bridge-vlan interface={trunk-порты} frame-types=admit-only-vlan-tagged ingress-filtering=yes;

    - interface bridge port add bridge=bridge-vlan interface={access-порты} pvid=20 frame-types=admit-only-untagged-and-priority-tagged ingress-filtering=yes; \# все ноуты в 20 влане
    
    - interface bridge vlan add bridge=bridge-vlan vlan-ids=20 tagged=bridge-vlan,{trunk-порты};
    
    - interface vlan add name=vlan20 interface=bridge-vlan vlan-id=20;
    
    - ip address add address=192.168.20.2/24 interface=vlan20;
    - ip route add gateway=192.168.20.1;
    
    - ip service set telnet disabled=yes;
    - ip service set ftp disabled=yes;
    - ip service set www disabled=yes;

    - interface bridge set bridge-vlan protocol-mode=rstp priority=0x4000;
    - interface bridge set bridge-vlan comment="ACCESS SWITCH";
]

#num_sub_head[
    Настройка точек доступа
]

#body_text[
    Для точек доступа реализован бесшовный роминг, что позволяет перемещаться сотрудникам внутри офиса без потери соединения и для нахождения максимально быстрого подключения. Также в локальной сети присутствуют вланы и требуется настроить на точках ssid для определенных вланов.
]

#dash_list[
    - interface wireless cap set enabled=yes caps-man-addresses=192.168.200.1 discovery-interfaces=bridge;
    - interface wifi cap set enabled=yes caps-man-addresses=192.168.200.1;
    
    - caps-man security add name=sec-dev authentication-types=wpa2-psk,wpa3-psk encryption=aes-ccm passphrase=349nvDKFfj;
    - caps-man security add name=sec-business authentication-types=wpa2-psk,wpa3-psk encryption=aes-ccm passphrase=I23h9FMoh3;
    - caps-man security add name=sec-guest authentication-types=wpa2-psk encryption=aes-ccm passphrase=NVff2h3g4o;

    - caps-man datapath add name=dp-dev bridge=bridge-vlan vlan-id={10,20,90} vlan-mode=use-tag local-forwarding=yes;

    - caps-man channel add name=ch-5ghz band=5ghz-ax frequency=5180,5260,5500,5580 width=20/40/80mhz;
    - caps-man channel add name=ch-2ghz band=2ghz-ax frequency=2412,2437,2462 width=20mhz;
    
    - caps-man configuration add name=cfg-dev ssid=Studio-Dev security=sec-dev datapath=dp-dev channel=ch-5ghz;
    - caps-man configuration add name=cfg-business ssid=Studio-Business security=sec-business datapath=dp-business channel=ch-5ghz;
    - caps-man configuration add name=cfg-guest ssid=Studio-Guests security=sec-guest datapath=dp-guest channel=ch-5ghz;
    
    - caps-man provisioning add action=create-dynamic-enabled master-configuration=cfg-dev slave-configurations=cfg-business,cfg-guest;
]

#num_sub_head[
    Настройка ip-телефонии
]

#body_text[
    Для организации телефонной связи используется облачная АТС Mango Office, что не требует развёртывания собственного серверного оборудования. В личном кабинете Mango Office создаются внутренние номера (extensions) для каждого сотрудника. На каждом ноутбуке MacBook Air (34 шт.) и системных блоках бизнес-отдела (11 шт.) устанавливается и настраивается программный телефон Linphone.
]

#num_sub_head[
    Настройка системы контроля версий и развертывания
]

#body_text[
    В проекте используется облачная версия Github, что исключает необходимость установки и поддержки собственного сервера. Каждый проект будет иметь свой монорепозиторий, состоящий из frontend_web, frontend_mobile и backend. backend будет представлять из себя api, фронтенд веб и мобилка будут делать асинхронные запросы к api. Разработчик сможет скачать монорепо и развернуть у себя локально через docker. Для автоматизации развертывания будет использоваться github actions и docker. Каждый репозиторий будет содержать две ветки git: develop и main. Если происходит коммит и push ветки main, скрипт из github actions будет запускаться, подключаться по ssh к vps и скачивать, билдить проекты из github. Данные аутентификации и docker-compose будут храниться в github secrets в зашифрованном виде.
]