namespace Ademero.NucleusOne.FolderMonitor.Service.Util;

internal interface IDateTimeOffsetProvider {
  /// <inheritdoc cref="DateTimeOffset.Now"></inheritdoc>
  DateTimeOffset Now { get; }

  /// <inheritdoc cref="DateTimeOffset.UtcNow"></inheritdoc>
  DateTimeOffset UtcNow { get; }
}

internal class DateTimeOffsetProvider : IDateTimeOffsetProvider {
  public DateTimeOffset Now => DateTimeOffset.Now;

  public DateTimeOffset UtcNow => DateTimeOffset.UtcNow;
}
