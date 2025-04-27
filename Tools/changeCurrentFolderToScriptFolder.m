function changeCurrentFolderToScriptFolder(verbose)
    % cdToScriptDir - 将当前工作目录切换到调用此函数的脚本或函数所在目录
    %
    % 输入参数:
    %   verbose - (可选) 布尔值，是否显示切换后的目录路径，默认 false
    %
    % 用法:
    %   在你的脚本中调用 cdToScriptDir()，即可将工作目录切换到该脚本所在的文件夹。

    if nargin < 1
        % verbose = false;
        verbose = true;
    end

    % 获取调用栈信息，跳过当前函数
    stack = dbstack(1);
    scriptFolder = '';

    if isempty(stack)
        scriptFolder = pwd;
        if verbose
            disp('未检测到调用者脚本，使用当前目录作为工作目录。');
        end
    else
        % 获取调用者的文件路径
        callerFile = stack(1).file;
        if verbose
            disp(['调用者文件路径 (原始): ', callerFile]);
        end
        
        if isempty(callerFile)
            scriptFolder = pwd;
            if verbose
                disp('调用者文件路径为空，使用当前目录作为工作目录。');
            end
        else
            % 如果 callerFile 只包含文件名，使用 which 获取完整路径
            if ~contains(callerFile, filesep) % 检查是否缺少路径分隔符
                fullCallerFile = which(callerFile);
                if isempty(fullCallerFile)
                    scriptFolder = pwd;
                    if verbose
                        disp('无法通过 which 找到文件完整路径，使用当前目录作为工作目录。');
                    end
                else
                    callerFile = fullCallerFile;
                    if verbose
                        disp(['调用者文件路径 (完整): ', callerFile]);
                    end
                end
            end
            
            % 使用 fileparts 解析目录
            [scriptFolder, ~, ~] = fileparts(callerFile);
            if verbose
                disp(['解析后的目录: ', scriptFolder]);
            end
            
            if isempty(scriptFolder)
                scriptFolder = pwd;
                if verbose
                    disp('解析后的目录为空，使用当前目录作为工作目录。');
                end
            end
        end
    end

    % 切换当前工作目录
    if ~isempty(scriptFolder)
        try
            cd(scriptFolder);
            if verbose
                disp(['成功切换到目录: ', scriptFolder]);
            end
        catch ME
            warning('无法切换到目录 "%s": %s。保持当前目录不变。', scriptFolder, ME.message);
            scriptFolder = pwd;
        end
    else
        scriptFolder = pwd;
        if verbose
            disp('目录路径为空，使用当前目录作为工作目录。');
        end
    end

    if verbose
        disp(['当前工作目录: ', pwd]);
    end
end