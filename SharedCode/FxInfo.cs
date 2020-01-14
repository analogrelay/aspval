using System.Runtime.InteropServices;
using System.Text;
using Microsoft.AspNetCore.Http;

public static class FxInfo
{
    public static string Get()
    {
        var builder = new StringBuilder();
        builder.AppendLine($"Framework: {RuntimeInformation.FrameworkDescription}");
        builder.AppendLine($"OS: {RuntimeInformation.OSDescription} ({RuntimeInformation.OSArchitecture})");
        builder.AppendLine($"Arch: {RuntimeInformation.ProcessArchitecture}");
        builder.AppendLine($"ASP.NET Core Path: {typeof(HttpContext).Assembly.Location}");
        builder.AppendLine($".NET Core Path: {typeof(string).Assembly.Location}");
    }
}