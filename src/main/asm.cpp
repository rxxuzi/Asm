#include <iostream>
#include <string>
#include <filesystem>

// ディレクトリが存在するか確認し、存在しない場合は作成する
void ensure_directory_exists(const std::string& dir) {
    if (!std::filesystem::exists(dir)) {
        std::filesystem::create_directories(dir);
    }
}

int main() {
    // ユーザー入力用の変数
    std::string project_name, option, architecture;

    // デフォルト設定
    std::string project_dir = "asm";
    std::string obj_dir = "asm-out";
    std::string exe_dir = "run";
    std::string log_dir = "log";

    // ユーザーからの入力を受け取る
    std::cout << "project name: ";
    std::getline(std::cin, project_name);

    std::cout << "option [a/b/c/r/x]: ";
    std::getline(std::cin, option);

    // a, b, c が選択された場合のみアーキテクチャを尋ねる
    if (option == "a" || option == "b" || option == "c") {
        std::cout << "architecture [32/64]: ";
        std::getline(std::cin, architecture);
    }

    // ディレクトリの存在を確認
    ensure_directory_exists(obj_dir);
    ensure_directory_exists(exe_dir);
    ensure_directory_exists(log_dir);

    // コンパイルとリンクのコマンドを構築
    // コンパイルとリンクのコマンドを構築
    // コンパイルとリンクのコマンドを構築
    if (option == "a" || option == "b" || option == "c") {
        std::string asm_command = "nasm -f " + std::string(architecture == "64" ? "win64" : "win32") + " " + project_dir + "/" + project_name + ".asm -o " + obj_dir + "/" + project_name + ".obj";
        std::string gcc_command = "gcc -c -m" + architecture + " " + project_dir + "/" + project_name + ".c -o " + obj_dir + "/" + project_name + ".o";

        // コンパイルコマンドを実行
        system(asm_command.c_str());
        system(gcc_command.c_str());

        // オプションが c または b の場合はリンクする
        if (option == "c" || option == "b") {
            std::string link_command = "gcc " + obj_dir + "/" + project_name + ".o " + obj_dir + "/" + project_name + ".obj -o " + exe_dir + "/" + project_name + ".exe";
            system(link_command.c_str());
        }

        // オプションが b の場合、中間ファイルを削除
        if (option == "b") {
            std::filesystem::remove(obj_dir + "/" + project_name + ".o");
            std::filesystem::remove(obj_dir + "/" + project_name + ".obj");
        }
    }
    else if (option == "r") {
        // ファイル削除
        std::filesystem::remove(obj_dir + "/" + project_name + ".o");
        std::filesystem::remove(obj_dir + "/" + project_name + ".obj");
        std::filesystem::remove(exe_dir + "/" + project_name + ".exe");
    } else if (option == "x") {
        // すべてのファイル削除
        std::filesystem::remove(project_dir + "/" + project_name + ".asm");
        std::filesystem::remove(project_dir + "/" + project_name + ".c");
        std::filesystem::remove(obj_dir + "/" + project_name + ".o");
        std::filesystem::remove(obj_dir + "/" + project_name + ".obj");
        std::filesystem::remove(exe_dir + "/" + project_name + ".exe");
    }

    return 0;
}
