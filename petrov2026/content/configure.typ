#import "../shared.typ": *

#num_head[
    Настройка оборудования
]

#body_text[
    Настройка оборудования — это важный этап в процессе внедрения и эксплуатации любой системы. Правильная настройка обеспечивает оптимальную работу устройств, их совместимость и безопасность, что в конечном итоге влияет на эффективность работы всей организации.

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
    Настройка оборудования имеет следующий вид:
]

#dash_list[

    - \# Создание пользователя
    - /user set admin password=32FHE&lka;

    - /interface vlan add name=vlan10 vlan-id=10 interface=ether1;
    - /interface vlan add name=vlan20 vlan-id=20 interface=ether1;
    - /interface vlan add name=vlan90 vlan-id=90 interface=ether1;
    - /interface vlan add name=vlan100 vlan-id=100 interface=ether1;

    - /ip address add address=192.168.10.1/24 interface=vlan10;
    - /ip address add address=192.168.20.1/24 interface=vlan20;
    - /ip address add address=192.168.90.1/24 interface=vlan90;
    - /ip address add address=192.168.100.1/24 interface=vlan100;

    - \# Создание пулов адресов
    - /ip pool add name=pool-vlan10 ranges=192.168.10.10-192.168.10.250
    - /ip pool add name=pool-vlan20 ranges=192.168.20.10-192.168.20.250
    - /ip pool add name=pool-vlan90 ranges=192.168.90.10-192.168.90.250
    - /ip pool add name=pool-vlan100 ranges=192.168.100.10-192.168.100.250

    - \# Настройка DHCP-сервера для VLAN 10
    - /ip dhcp-server add name=dhcp-vlan10 interface=vlan10 address-pool=pool-vlan10
    - /ip dhcp-server network add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=8.8.8.8,1.1.1.1

    - \# Аналогично для VLAN 20, 90, 100
    - /ip dhcp-server add name=dhcp-vlan20 interface=vlan20 address-pool=pool-vlan20
    - /ip dhcp-server network add address=192.168.20.0/24 gateway=192.168.20.1 dns-server=8.8.8.8,1.1.1.1

    - /ip dhcp-server add name=dhcp-vlan90 interface=vlan90 address-pool=pool-vlan90
    - /ip dhcp-server network add address=192.168.90.0/24 gateway=192.168.90.1 dns-server=8.8.8.8,1.1.1.1

    - /ip dhcp-server add name=dhcp-vlan100 interface=vlan100 address-pool=pool-vlan100
    - /ip dhcp-server network add address=192.168.100.0/24 gateway=192.168.100.1 dns-server=8.8.8.8,1.1.1.1

    - \# Запуск всех DHCP-серверов
    - /ip dhcp-server enable [find]

]

#num_sub_head[
    Настройка коммутатора уровня распределения
]

#body_text[
    Настройка оборудования имеет следующий вид:
]

#dash_list[
    - \# Сброс и базовая настройка;
    - /system reset-configuration;
    - /system identity set name=CRS328-Access;

    - \# Настройка порта аплинка к магистральному коммутатору (SFP+);
    - /interface ethernet set sfp-sfpplus1 speed=10Gbps;
    - /interface bridge add name=bridge-vlan vlan-filtering=yes;

    - \# Добавление портов в бридж;
    - /interface bridge port add bridge=bridge-vlan interface=ether1 (аплинк в транке);
    - /interface bridge port add bridge=bridge-vlan interface=ether2-ether24 pvid=100 (камеры);

    - \# Настройка VLAN на бридже;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=10 tagged=sfp-sfpplus1;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=20 tagged=sfp-sfpplus1;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=90 tagged=sfp-sfpplus1;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=100 tagged=sfp-sfpplus1;

    - \# Включение PoE на портах для камер и точек доступа;
    - /interface poe set ether2-ether24 poe-out=auto-on;
]

#num_sub_head[
    Настройка коммутатора уровня доступа
]

#body_text[
    Настройка оборудования имеет следующий вид:
]

#dash_list[
    - \# Сброс и базовая настройка;
    - /system reset-configuration;
    - /system identity set name=CRS328-Access;

    - \# Настройка порта аплинка к магистральному коммутатору (SFP+);
    - /interface ethernet set sfp-sfpplus1 speed=10Gbps;
    - /interface bridge add name=bridge-vlan vlan-filtering=yes;

    - \# Добавление портов в бридж;
    - /interface bridge port add bridge=bridge-vlan interface=ether1 (аплинк в транке);
    - /interface bridge port add bridge=bridge-vlan interface=ether2-ether24 pvid=100 (камеры);

    - \# Настройка VLAN на бридже;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=10 tagged=sfp-sfpplus1;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=20 tagged=sfp-sfpplus1;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=90 tagged=sfp-sfpplus1;
    - /interface bridge vlan add bridge=bridge-vlan vlan-id=100 tagged=sfp-sfpplus1;

    - \# Включение PoE на портах для камер и точек доступа;
    - /interface poe set ether2-ether24 poe-out=auto-on.
]

#num_sub_head[
    Настройка точек доступа
]

#body_text[
    Настройка оборудования имеет следующий вид:
]

#dash_list[
    - \# На маршрутизаторе RB5009 включение CAPsMAN;
    - /caps-man manager set enabled=yes;

    - \# Создание конфигурации для точек доступа;
    - /caps-man configuration add name=cfg-studio ssid=Studio-Staff security.authentication-types=wpa2-psk security.passphrase=сильный_пароль datapath.bridge=bridge-vlan vlan-id=10;

    - /caps-man configuration add name=cfg-guests ssid=Studio-Guests security.authentication-types=wpa2-psk security.passphrase=гостевой_пароль datapath.bridge=bridge-vlan vlan-id=90;

    - \# Применение конфигурации ко всем точкам доступа;
    - /caps-man provisioning add action=create-dynamic-enabled master-configuration=cfg-studio;

    - \# Настройка радиоинтерфейсов (2.4 ГГц и 5 ГГц);
    - /caps-man channel add name=ch-2ghz band=2ghz-ax frequency=2412,2437,2462 width=20mhz;
    - /caps-man channel add name=ch-5ghz band=5ghz-ax frequency=5180,5200,5220,5240 width=40mhz,80mhz;

    - /caps-man datapath add name=dp-studio bridge=bridge-vlan client-to-client-forwarding=yes;
    - /caps-man datapath add name=dp-guests bridge=bridge-vlan client-to-client-forwarding=no vlan-id=90.
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
    В проекте используется облачная версия Github, что исключает необходимость установки и поддержки собственного сервера. Каждый проект будет иметь свой монорепозиторий, состоящий из frontend_web, frontend_mobile и backend. backend будет представлять из себя api, фронтенд веб и мобилка будут делать асинхронные запросы к api.d Разработчик сможет скачать монорепо и развернуть у себя локально через docker. Для автоматизации развертывания будет использоваться github actions и docker. Каждый репозиторий будет содержать две ветки git: develop и main. Если происходит коммит и push ветки main, скрипт из github actions будет запускаться, подключаться по ssh к vps и скачивать, билдить проекты из github. Данные аутентификации и docker-compose будут храниться в github secrets в зашифрованном виде.
]