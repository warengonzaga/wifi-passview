import platform

if platform.system() == "Windows":
    from src.wifi_pass_view_windows import main_menu
    main_menu()
else:
    from src.wifi_pass_view_linux import main_menu
    main_menu()