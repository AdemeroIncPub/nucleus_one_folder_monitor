namespace Ademero.NucleusOne.FolderMonitor.Service.Util;

internal interface IDateTimeProvider {
  /// <inheritdoc cref="DateTime.UtcNow"></inheritdoc>
  DateTime UtcNow { get; }

  /// <inheritdoc cref="DateTime.Now"></inheritdoc>
  DateTime Now { get; }
}

internal class DateTimeProvider : IDateTimeProvider {
  public DateTime Now => DateTime.Now;

  public DateTime UtcNow => DateTime.UtcNow;
}
