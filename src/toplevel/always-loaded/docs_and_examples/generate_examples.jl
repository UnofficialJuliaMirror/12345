import Literate

function preprocess_example_shared(
        content::AbstractString;
        output_directory::AbstractString,
        )::String
    content = replace(content,
                      "## %PREDICTMD_GENERATED_BY%\n" =>
                          string("## This file was generated by PredictMD ",
                                 "version $(version()), ",
                                 "code name $(version_codename())",
                                 "\n",
                                 "## For help, please visit ",
                                 "https://predictmd.net",
                                 "\n",))
    return content
end

function get_if_include_test_statements_regex()::Regex
    test_statements_regex::Regex = r"# PREDICTMD IF INCLUDE TEST STATEMENTS\n([\S\s]*?)# PREDICTMD ELSE\n([\S\s]*?)# PREDICTMD ENDIF INCLUDE TEST STATEMENTS\n{0,5}"
    return test_statements_regex
end

function preprocess_example_do_not_include_test_statements(
        content::AbstractString;
        output_directory::AbstractString,
        )::String
    content::String = preprocess_example_shared(
        content;
        output_directory = output_directory,
        )
    test_statements_regex::Regex = get_if_include_test_statements_regex()
    for m in eachmatch(test_statements_regex, content)
        original_text::String = String(m.match)
        replacement_text = string(strip(String(m[2])), "\n\n",)
        content = replace(content, original_text => replacement_text)
    end
    content = replace(content, r"logger_stream, " => "")
    return content
end

function preprocess_example_include_test_statements(
        content::AbstractString;
        output_directory::AbstractString,
        )::String
    content::String = preprocess_example_shared(
        content;
        output_directory = output_directory,
        )
    test_statements_regex::Regex = get_if_include_test_statements_regex()
    for m in eachmatch(test_statements_regex, content)
        content = replace(content,
                          String(m.match) =>
                              string(strip(String(m[1])), "\n\n",))
    end
    return content
end

function fix_example_blocks(filename::AbstractString)::Nothing
    if filename_extension(filename) == ".md"
        content = read(filename, String)
        rm(filename; force = true, recursive = true,)
        content = replace(content, r"```@example \w*\n" => "```julia\n")
        write(filename, content)
    end
    return nothing
end

function generate_examples(
        output_directory::AbstractString;
        execute_notebooks = false,
        markdown = false,
        notebooks = false,
        scripts = false,
        include_test_statements::Bool = false,
        )::String
    _abspath_output_directory::String = abspath(output_directory)
    if Sys.iswindows()
        execute_notebooks = false
    end
    ENV["PREDICTMD_IS_MAKE_EXAMPLES"] = "true"
    if !markdown && !notebooks && !scripts
        error(
            string(
                "At least one of markdown, notebooks, scripts must be true.",
                )
            )
    end
    if ispath(output_directory)
        error(
            string(
                "The output directory already exists. ",
                "Delete the output directory and then ",
                "re-run generate_examples."
                )
            )
    end

    if include_test_statements
        preprocess_example = (x) ->
            preprocess_example_include_test_statements(
                x;
                output_directory = _abspath_output_directory,
                )
    else
        preprocess_example = (x) ->
            preprocess_example_do_not_include_test_statements(
                x;
                output_directory = _abspath_output_directory,
                )
    end

    @debug("Starting to generate examples...")

    temp_examples_dir = joinpath(
        maketempdir(),
        "generate_examples",
        "PredictMDTemp",
        "docs",
        "src",
        "examples",
        )
    try
        mkpath(temp_examples_dir)
    catch
    end

    examples_input_parent_directory =
        PredictMD.package_directory("templates", "examples")

    cpu_examples_input_parent_directory = joinpath(
        examples_input_parent_directory,
        "cpu_examples",
        )
    cpu_examples_output_parent_directory = joinpath(
        temp_examples_dir,
        "cpu_examples",
        )
    try
        mkpath(cpu_examples_output_parent_directory)
    catch
    end

    boston_housing_input_directory = joinpath(
        cpu_examples_input_parent_directory,
        "boston_housing",
        )
    boston_housing_output_directory = joinpath(
        cpu_examples_output_parent_directory,
        "boston_housing",
        )

    boston_housing_input_src_directory = joinpath(
        boston_housing_input_directory,
        "src",
        )
    boston_housing_output_src_directory = joinpath(
        boston_housing_output_directory,
        "src",
        )
    try
        mkpath(boston_housing_output_directory)
        mkpath(boston_housing_output_src_directory)
    catch
    end
    for x in [".gitignore", "Project.toml", "README.md"]
        cp(joinpath(boston_housing_input_directory, x),
           joinpath(boston_housing_output_directory, x);
           force=true)
    end
    boston_housing_input_file_list =
        readdir(boston_housing_input_src_directory)
    boston_housing_input_file_list =
        boston_housing_input_file_list[
            [endswith(x, ".jl") for x in
                boston_housing_input_file_list]
            ]
    sort!(boston_housing_input_file_list)
    for input_file in boston_housing_input_file_list
        input_file_full_path = joinpath(
            boston_housing_input_src_directory,
            input_file,
            )
        if markdown
            Literate.markdown(
                input_file_full_path,
                boston_housing_output_src_directory;
                codefence = "```@example boston_housing" => "```",
                documenter = true,
                preprocess = preprocess_example,
                )
        end
        if notebooks
            Literate.notebook(
                input_file_full_path,
                boston_housing_output_src_directory;
                documenter = true,
                execute = execute_notebooks,
                preprocess = preprocess_example,
                )
        end
        if scripts
            Literate.script(
                input_file_full_path,
                boston_housing_output_src_directory;
                documenter = true,
                keep_comments = true,
                preprocess = preprocess_example,
                )
        end
    end

    breast_cancer_biopsy_input_directory = joinpath(
        cpu_examples_input_parent_directory,
        "breast_cancer_biopsy",
        )
    breast_cancer_biopsy_output_directory = joinpath(
        cpu_examples_output_parent_directory,
        "breast_cancer_biopsy",
        )

    breast_cancer_biopsy_input_src_directory = joinpath(
        breast_cancer_biopsy_input_directory,
        "src",
        )
    breast_cancer_biopsy_output_src_directory = joinpath(
        breast_cancer_biopsy_output_directory,
        "src",
        )
    try
        mkpath(breast_cancer_biopsy_output_directory)
        mkpath(breast_cancer_biopsy_output_src_directory)
    catch
    end
    for x in [".gitignore", "Project.toml", "README.md"]
        cp(joinpath(breast_cancer_biopsy_input_directory, x),
           joinpath(breast_cancer_biopsy_output_directory, x);
           force=true)
    end
    breast_cancer_biopsy_input_file_list =
        readdir(breast_cancer_biopsy_input_src_directory)
    breast_cancer_biopsy_input_file_list =
        breast_cancer_biopsy_input_file_list[
            [endswith(x, ".jl") for x in
                breast_cancer_biopsy_input_file_list]
            ]
    sort!(breast_cancer_biopsy_input_file_list)
    for input_file in breast_cancer_biopsy_input_file_list
        input_file_full_path = joinpath(
            breast_cancer_biopsy_input_src_directory,
            input_file,
            )
        if markdown
            Literate.markdown(
                input_file_full_path,
                breast_cancer_biopsy_output_src_directory;
                codefence = "```@example breast_cancer_biopsy" => "```",
                documenter = true,
                preprocess = preprocess_example,
                )
        end
        if notebooks
            Literate.notebook(
                input_file_full_path,
                breast_cancer_biopsy_output_src_directory;
                documenter = true,
                execute = execute_notebooks,
                preprocess = preprocess_example,
                )
        end
        if scripts
            Literate.script(
                input_file_full_path,
                breast_cancer_biopsy_output_src_directory;
                documenter = true,
                keep_comments = true,
                preprocess = preprocess_example,
                )
        end
    end

    for (root, dirs, files) in walkdir(temp_examples_dir)
        for f in files
            filename = joinpath(root, f)
            fix_example_blocks(filename)
        end
    end

    try
        mkpath(dirname(output_directory))
    catch
    end

    cp(
        temp_examples_dir,
        output_directory;
        force = true,
        )

    @debug(
        string(
            "Finished generating examples. ",
            "Files were written to: \"",
            output_directory,
            "\".",
            )
        )
    ENV["PREDICTMD_IS_MAKE_EXAMPLES"] = "false"
    return output_directory
end
